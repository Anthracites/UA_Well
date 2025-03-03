import Foundation
import UIKit

class ContactCell: UICollectionViewCell
{
    var linkURL: String!
    @IBOutlet weak var contactButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Инициализация
    }
    
    @objc func OnClickLinkButtonHandler()
    {
        print(String(linkURL))
        if let _url = URL(string: linkURL)
        {
            if contactButton.titleLabel?.text == "email"
            {
                print(TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailTitle )
                print(TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailBody )
            }
            else
            {
                UIApplication.shared.open(_url, options: [:], completionHandler: nil)
            }
        }
    }
}
