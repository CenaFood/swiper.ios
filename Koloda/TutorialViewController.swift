import UIKit
import Koloda
import pop
import TransitionButton
import Kingfisher
import CoreLocation
import CloudKit
import Instructions

private let numberOfStartingCards: Int = 12
private let numberOfDifferentCards: Int = 3
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class TutorialViewController: CustomTransitionViewController {
    var userID: String = ""
    fileprivate var startImages: [UIImage] = []
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var noFoodButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var coachMarksController = CoachMarksController()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartImages()
        setupStartImages()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.coachMarksController.overlay.allowTap = true
        
        
        kolodaView.clipsToBounds = true
        setupContinueButton()
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)
        self.coachMarksController.skipView = skipView
    }
    
    func setupContinueButton() {
        continueButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        continueButton.titleLabel?.font = font
        continueButton.setTitle("Continue", for: .normal)
    }
    
    func setupStartImages() {
        for i in 1...numberOfDifferentCards {
            self.startImages.append(UIImage(named: "startMeal" + "\(i)")!)
            self.startImages.append(UIImage(named: "startMeal" + "\(i)")!)

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(on: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    @IBAction func finishTutorialAction(_ sender: UIButton) {
         guard let user_id = UserDefaults.standard.value(forKey: "username") as? String else {
            print("Could not get iCloud identifier")
            return
        }
        let credentials = Identifier(identifier: user_id)
        CenaAPI().register(credentials: credentials)
        
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
}




//MARK: KolodaViewDelegate
extension TutorialViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
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
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
        
    
}

// MARK: KolodaViewDataSource
extension TutorialViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.startImages.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view: UIImageView = UIImageView()
        view.image = self.startImages[index]
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

// MARK: CoachMarksControllerDataSource
extension TutorialViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        print("We are at index: \(index)")
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "Swipe right if you like to eat this here and now."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 1:
            coachViews.bodyView.hintLabel.text = "Or press the green like button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 2:
            coachViews.bodyView.hintLabel.text = "Swipe left if you don't like to eat this here and now."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 3:
            coachViews.bodyView.hintLabel.text = "Or press the red dislike button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 4:
            coachViews.bodyView.hintLabel.text = "Swipe up if there is no food on the picture."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 5:
            coachViews.bodyView.hintLabel.text = "Or press the blue no food button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 6:
            coachViews.bodyView.hintLabel.text = "Now it's your turn. Try it out!"
            coachViews.bodyView.nextLabel.text = "Ok"
        default:
            break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }


    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 7
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0, 2, 4, 6:
            return coachMarksController.helper.makeCoachMark(for: self.kolodaView)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.likeButton)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.dislikeButton)
        case 5:
            return coachMarksController.helper.makeCoachMark(for: self.noFoodButton)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
}

// MARK: CoachMarksControllerDelegate
extension TutorialViewController: CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        switch index {
        case 0, 1:
            self.kolodaView.swipe(.right)
        case 2, 3:
            self.kolodaView.swipe(.left)
        case 4, 5:
            self.kolodaView.swipe(.up)
        default:
            break
        }
    }
}



