import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class SummaryViewController: UIViewController {
    @IBOutlet weak var startView: UIImageView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartImage()
    }
    
    //MARK: Private methods
    func setupStartImage() {
        startView.layer.cornerRadius = 8.0
        startView.clipsToBounds = true
        let startImage = UIImage(named: "summary")!
        startView.image = startImage
    }
}


