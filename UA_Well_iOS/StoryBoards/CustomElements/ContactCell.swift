import UIKit

class ContactCell: UICollectionViewCell {
    var linkURL: String!
    var mailTitle, mailBody: String!
    @IBOutlet weak var contactButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Инициализация
        contactButton.addTarget(self, action: #selector(OnClickLinkButtonHandler), for: .touchUpInside)
    }

    @objc func OnClickLinkButtonHandler() {
        if let _url = URL(string: linkURL) {
            if contactButton.titleLabel?.text == "email" {
                let subject = mailTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let body = mailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let mailtoURL = "mailto:\(String(describing: linkURL))?subject=\(subject)&body=\(body)"
                
                if let url = URL(string: mailtoURL) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                UIApplication.shared.open(_url, options: [:], completionHandler: nil)
            }
        }
    }
}
