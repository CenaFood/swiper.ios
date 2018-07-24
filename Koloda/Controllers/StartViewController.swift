import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton
import ActiveLabel
import RLBAlertsPickers

struct KeychhainConfiguration {
    static let serviceName = "CenaSwiper"
    static let accessGroup: String? = nil   
}

class StartViewController: UIViewController {
    var passwordItems: [KeychainPasswordItem] = []
    let startTutorialButtonTag = 0
    let startDiscoveringButtonTag = 1
    let customType = ActiveType.custom(pattern: Legal.TermsAndPrivacyRegex)
    
//    let termsAndPolicyLabel = ActiveLabel()
    
    @IBOutlet weak var startTutorialButton: UIButton!
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
    @IBAction func startTutorialAction(_ sender: UIButton) {
        // TODO: Switch to promises or reactive programming
        AuthController().saveCloudKitIdentifier()
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
    
    
    func testAPI() {
        let email = "helloichbins123"
        let password = "sindwirschonda123"
        let credentials = Credentials(email: email, password: password)
        //let credentials = Identifier(identifier: "_dd34f6e7e339e18c795d4f380403c091")
        print("Starting test")
        CenaAPI().register(credentials: credentials)
        //CenaAPI().login(credentials: credentials)
    }
}


