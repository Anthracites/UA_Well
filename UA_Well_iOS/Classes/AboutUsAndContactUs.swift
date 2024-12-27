import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        okButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
    }
    
    
    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }

}
