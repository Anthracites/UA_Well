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

//        if let _url = URL(string: linkURL)
//        {
//            UIApplication.shared.open(_url, options: [:], completionHandler: nil)
//        }
    }
}
