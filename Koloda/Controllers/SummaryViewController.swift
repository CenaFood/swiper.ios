import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class SummaryViewController: UIViewController {
    @IBOutlet weak var startView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartImage()
        setupContinueButton()
    }
    
    //MARK: Private methods
    func setupStartImage() {
        startView.layer.cornerRadius = 8.0
        startView.clipsToBounds = true
        let startImage = UIImage(named: "summary")!
        startView.image = startImage
    }
    
    func setupContinueButton() {
        continueButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        continueButton.titleLabel?.font = font
        continueButton.setTitle("Continue", for: .normal)
    }
}


