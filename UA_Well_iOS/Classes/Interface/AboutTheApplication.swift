import UIKit
import Foundation

class AboutTheApplication: UIViewController
{
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var appDescription: UITextView!
    @IBOutlet weak var abouAppLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TranslateView()
        okButton.addTarget(self, action: #selector(OkButtonHandler), for: .touchUpInside)

    }
    
@objc func TranslateView()
    {
        appDescription.text = TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppDescription
        abouAppLabel.text = TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppTitle
    }
    
    @objc func OkButtonHandler()
    {
        dismiss(animated: true, completion: nil)
    }
}
