import Foundation
import UIKit
import TransitionButton
import ActiveLabel
import RLBAlertsPickers
import PromiseKit

struct KeychhainConfiguration {
    static let serviceName = "CenaSwiper"
    static let accessGroup: String? = nil   
}

class StartViewController: UIViewController {
    var passwordItems: [KeychainPasswordItem] = []
    let startTutorialButtonTag = 0
    let startDiscoveringButtonTag = 1
    let customType = ActiveType.custom(pattern: Legal.TermsAndPrivacyRegex)
    let alertTitle = "No iCloud Account"
    let alertMessage = "It seems that you are not signed in with an iCloud account. We use your iCloud account to identify you so that you don't have to create any profile. Please sign in with an iCloud account and make sure that you are connected to the internet."
    
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var startTutorialButton: TransitionButton!
    @IBOutlet weak var termsAndPolicyLabel: ActiveLabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        setupStartButton()
        setupTermsAndPolicyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        termsAndPolicyLabel.handleCustomTap(for: customType) { legalType in
            self.showLegalAlert(legalType: legalType)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: IBActions
    @IBAction func startTutorialAction(_ button: TransitionButton) {
        button.startAnimation()
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.asyncAfter(deadline: .now() + 1) {
            firstly {
                AuthController().saveCloudKitIdentifier()
                }.done { userId -> Void in
                    UserDefaults.standard.setValue(userId, forKey: "username")
                    DispatchQueue.main.async {
                        button.stopAnimation(animationStyle: .expand, completion: {
                            self.performSegue(withIdentifier: "ShowAboutUsIntro", sender: nil)
                        })
                    }
                    
                }.catch { _ in
                        DispatchQueue.main.async {
                            button.stopAnimation(animationStyle: .shake, completion: {
                                let alert = Util.createSimpleAlert(title: self.alertTitle, message: self.alertMessage)
                                self.present(alert, animated: true)
                            })
                    }
                    
            }
        }
    }
    
    //MARK: Private methods

    
    func setupTermsAndPolicyLabel() {
        termsAndPolicyLabel.customize { label in
            label.numberOfLines = 0
            label.enabledTypes = [customType]
            label.text = "By using this application you agree to our \(Legal.TermsOfService) and \(Legal.PrivacyPolicy)"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            label.customColor[customType] = UIColor.init(named: "tealBlue")
        }
    }
    
    func showLegalAlert(legalType: String) {
        let alert = UIAlertController(style: .actionSheet)
        guard let legalText: [AttributedTextBlock] = Legal.legalTypeToText[legalType] else {
            print("Error: wrong legalType: \(legalType)")
            return
        }
        alert.addTextViewer(text: .attributedText(legalText))
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    func setupStartButton() {
        startTutorialButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        startTutorialButton.titleLabel?.font = font
        startTutorialButton.setTitle("Accept And Start Tutorial", for: .normal)
    }
}


