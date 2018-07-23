import UIKit
import Koloda
import pop
import TransitionButton
import Kingfisher
import CoreLocation
import CloudKit
import Reachability

private let numberOfStartingCards: Int = 10
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: CustomTransitionViewController {

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var userID: String = ""


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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if reachability.connection == .none {
            self.showNoInteretConnectionAlert(message: "Make sure that airplane mode is turned off and then press the refresh button")
        }
    }
    
    //MARK: Private functions

    func setupQuestionLabel() {
        questionLabel.text = "Would you eat this here and now?"
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
            // TODO: uncomment again when userID bug is fixed
//            let userID: String = self.credentials?.email ?? DummyUser.userID
            let userID: String = DummyUser.userID
            let annotation: Annotation = Annotation(challengeID: challenge.id, userID: userID, answer: "", location: nil, localTime: nil)
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
            print("Error: Could not determine the location")
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
extension BackgroundAnimationViewController: KolodaViewDelegate {

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
    }

    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }

}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {

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

extension BackgroundAnimationViewController: CLLocationManagerDelegate {

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

