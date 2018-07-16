import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton

struct KeychhainConfiguration {
    static let serviceName = "CenaSwiper"
    static let accessGroup: String? = nil   
}

class StartViewController: UIViewController {
    var passwordItems: [KeychainPasswordItem] = []
    let startTutorialButtonTag = 0
    let startDiscoveringButtonTag = 1
    
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var startView: UIImageView!
    @IBOutlet weak var startTutorialButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        setupStartImage()
        setupStartButton()
        //CenaAPI().saveCloudKitIdentifier()
        testAPI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func startTutorialAction(_ sender: UIButton) {
        
    }
    
    //MARK: Private methods
    
    func registerUser() {
        
    }
    
    func setupTitle() {
        welcomeTitle.layer.cornerRadius = 8.0
    }
    
    func setupStartButton() {
        startTutorialButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        startTutorialButton.titleLabel?.font = font
        startTutorialButton.setTitle("Start Tutorial", for: .normal)
    }
    
    func setupStartImage() {
        startView.layer.cornerRadius = 8.0
        startView.clipsToBounds = true
        let startImage = UIImage(named: "start")!
         startView.image = startImage
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


