import UIKit
import Koloda
import pop
import TransitionButton
import Kingfisher
import CoreLocation
import CloudKit
import Reachability
import PromiseKit

private let numberOfStartingCards: Int = 10
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class DiscoverViewController: CustomTransitionViewController {

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var userID: String = ""
    
    var userSwipesCount: Int = 0
    var currentDiscoverLevel: Int = 0
    var communitySwipesCount: Int = 0


    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    

    fileprivate var challenges: [Challenge] = []
    fileprivate var annotations: [Annotation] = []
    fileprivate var dataSource: [URL] = []
    fileprivate var credentials: Credentials? = AuthController().getCredentials()
    fileprivate let default_image: UIImage = UIImage(named: "summary")!
    let reachability = Reachability()!
    


    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

        setupQuestionLabel()
        setupLocationManager()
        kolodaView.clipsToBounds = true
        fetchImages()
        
        userSwipesCount = UserDefaults.standard.value(forKey: "userSwipesCount") as? Int ?? 0
        communitySwipesCount = UserDefaults.standard.value(forKey: "communitySwipesCount") as? Int ?? 0
        currentDiscoverLevel = UserDefaults.standard.value(forKey: "currentDiscoverLevel") as? Int ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if reachability.connection == .none {
            self.showNoInteretConnectionAlert(message: "Make sure that airplane mode is turned off and then press the refresh button")
            
        }
        AuthController().login()
        setSwipesCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveUserSwipesCount()
        saveCommunitySwipesCount()
        
    }
    
    //MARK: Private functions
    
    func saveUserSwipesCount() {
        UserDefaults.standard.setValue(userSwipesCount, forKey: "userSwipesCount")
    }
    
    func saveCommunitySwipesCount() {
        UserDefaults.standard.setValue(communitySwipesCount, forKey: "communitySwipesCount")
    }
    
    func saveCurrentDiscoverLevel() {
        UserDefaults.standard.setValue(currentDiscoverLevel, forKey: "currentDiscoverLevel")
    }

    func setupQuestionLabel() {
        questionLabel.text = "Would you like to eat or drink this?"
        let size = UIFont.labelFontSize
        let font = UIFont.systemFont(ofSize: size)
        questionLabel.font = font
    }

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func showNoInteretConnectionAlert(message: String) {
        let alert = UIAlertController(title: "No Internet Connection", message: message,
                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    func fetchImages() {
        CenaAPI().prefetchImages() { challenges, urls in
            self.challenges = challenges
            self.dataSource = urls
            self.setupAnnotations()
            self.locationManager?.requestLocation()
            self.kolodaView.resetCurrentCardIndex()
        }

    }
    
    private func isConnectedToInternet() -> Bool {
        return reachability.connection != .none
    }
    
    private func hasLocationServiceAllowed() -> Bool {
        return CLLocationManager.authorizationStatus() != .denied
    }
    
    private func askForLocationPermission() {
        let alert = UIAlertController(title: "Location Services Off", message: "Turn on location settings in cena",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            } else {
                print("Error: Could not open Cena settings")
            }
        }
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }

    func setupAnnotations() {
        for challenge in challenges {
            let annotation: Annotation = Annotation(challengeID: challenge.id, answer: "", location: nil, localTime: nil)
            annotations.append(annotation)
        }
    }

    func updateAnnotations() {
        for annotation in annotations {
            CenaAPI().postAnnotations(annotation: annotation)
        }
    }

    func updateAnnotation(index: Int, answer: String) {
        guard let latitude = currentLocation?.coordinate.latitude, let longitude = currentLocation?.coordinate.longitude else {
            return
        }
        let location = Location(latitude: latitude, longitude: longitude)
        annotations[index].answer = answer
        annotations[index].latitude = location.latitude
        annotations[index].longitude = location.longitude
        annotations[index].localTime = currentLocation?.timestamp
        CenaAPI().postAnnotations(annotation: annotations[index])
    }


    //MARK: IBActions
    @IBAction func dislikeButtonTapped() {
        kolodaView?.swipe(.left)
    }

    @IBAction func likeButtonTapped() {
        kolodaView?.swipe(.right)
    }

    @IBAction func noFoodButtonTapped() {
        kolodaView?.swipe(.up)
    }

    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }

    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        if !isConnectedToInternet() {
            self.showNoInteretConnectionAlert(message: "Still in airplane mode? Please make sure that your device is connected to the internet. Thanks you are awesome!")
            return
        }
        refreshButton.isEnabled = false
        
        guard let credentials = AuthController().getCredentials() else {
            return
        }
        CenaAPI().login(credentials: credentials)
        fetchImages()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshButton.isEnabled = true
        }
    }
}




//MARK: KolodaViewDelegate
extension DiscoverViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        fetchImages()
    }

    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }

    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }

    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }

    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if !hasLocationServiceAllowed() {
            self.kolodaView.revertAction()
            askForLocationPermission()
            return
        }
        if !isConnectedToInternet() {
            self.kolodaView.revertAction()
            self.showNoInteretConnectionAlert(message: "Still in airplane mode? Please make sure that your device is connected to the internet. Thanks you are awesome!")
            return
        }
        if direction == SwipeResultDirection.right {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "Yes")
        } else if direction == SwipeResultDirection.left {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "No")
        } else if direction == SwipeResultDirection.up {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "No Food")
        }
        userSwipesCount += 1
        if currentDiscoverLevel < level {
            currentDiscoverLevel = level
            saveCurrentDiscoverLevel()
            Util.presentBottomFloat(title: motivatingTitle[currentDiscoverLevel], description: motivatingText[currentDiscoverLevel], image: nil, color: AppleColors.orange)
            
        }
    }

    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up, .down]
    }

}

// MARK: KolodaViewDataSource
extension DiscoverViewController: KolodaViewDataSource {

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view: UIImageView = UIImageView()
        view.kf.indicatorType = .activity
        view.kf.setImage(with: dataSource[index])
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let view = Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
        view?.layer.cornerRadius = 8
        view?.clipsToBounds = true
        return view
    }
}

extension DiscoverViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }

    }
}

extension DiscoverViewController {
    
    var level: Int {
        switch percentageProgress {
        case 0..<5:
            return 0
        case 5..<15:
            return 1
        case 15..<25:
            return 2
        case 25..<40:
            return 3
        case 40..<50:
            return 4
        case 50..<60:
            return 5
        case 60..<70:
            return 6
        case 70..<80:
            return 7
        case 80..<90:
            return 8
        case 90..<100:
            return 9
        case 100..<150:
            return 10
        case 150..<200:
            return 11
        case 200..<300:
            return 12
        default:
            return currentDiscoverLevel
        }
    }
        
    var motivatingText: [String] {
        return ["If you see this you have found a hidden gem or a bug. Please let me know either way.",
                "Wow you have just completed your first swipes! Check out the progress on how your are doing and what the goal is.",
        "But stay strong, the time is never just right.",
        "Your doing great so far. Thank you for your contribution!",
            "Amazing work. Have a look in the progress tab.",
            "Half of it? Really only half of it?",
            "Never give up.",
            "Does your thumb hurt already? Keep going.",
            "Head over to the progress tab to see your well deserved new status.",
            "Get ready for the last swipes. You are awesome!",
            "You did it! Thank you, you are fantastic.",
            "You are hungry for more? So are we. Keep it up!",
            "You are one hell of a swiping expert. Thank you, we really appreciate it!"
        ]
    }
    
    var motivatingTitle: [String] {
        return ["Bug",
        "Great Work",
        "The Struggle Is Real",
        "No Pain, No Gain",
        "May I Call You Senior?",
        "Halfway There",
        "Closer And Closer",
        "Yeah",
        "What Should We Call You Now?",
        "Almost There",
        "Congratulations",
        "Overachiever",
        "Twice As Much, Twice As Good"
        ]
    }
    
    var userSwipesTarget: Int {
        return 400
    }
    
    var percentageProgress: Double {
        return Double(userSwipesCount) / Double(userSwipesTarget) * 100
    }
    
    func setSwipesCount() {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async {
            firstly {
                CenaAPI().getStats()
                }.done { projectStats -> Void in
                    for stat in projectStats {
                        if stat.projectName == classConstants.projectName {
                            self.userSwipesCount = stat.personalLabelsCount
                            self.communitySwipesCount = stat.labelCount
                        }
                    }
                }.catch { _ in
                    DispatchQueue.main.async {
                        let alert = Util.noInternetConnectionAlert()
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }

