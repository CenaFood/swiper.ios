import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class SummaryViewController: UIViewController {
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var startView: UIImageView!
    @IBOutlet weak var discoverButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartImage()
//        setupStartButton()
    }
    
    
    //MARK: Private methods
    
    func setupTitle() {
        welcomeTitle.layer.cornerRadius = 8.0
    }
    
    func setupStartButton() {
        discoverButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        discoverButton.titleLabel?.font = font
        discoverButton.setTitle("Discover Your Taste", for: .normal)
    }
    
    func setupStartImage() {
        startView.layer.cornerRadius = 8.0
        startView.clipsToBounds = true
        let startImage = UIImage(named: "summary")!
        startView.image = startImage
    }
    
    //MARK: IBActions
    
    @IBAction func discoverButtonPressed(_ sender: UIButton) {
        AuthController().login()
    }
}


