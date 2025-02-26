import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentViews: [SpecialistInfo]!
    @IBOutlet var generalView: UIView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewDescription: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        okButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        // Установка contentSize для UIScrollView
        TranslateView()
        AddSpecialistInfo()
        ScrollSetup()
    }
    @objc func TranslateView()
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        viewTitle.text = _translation?.aboutUsAndcontactUs?.Title
        viewDescription.text = _translation?.aboutUsAndcontactUs?.Description
    }
    
    @objc func AddSpecialistInfo()
    {
        if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts
        {
            var i:Int = 0;
            let _languagesLabel = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.LanguagesLabel
            let _contactsLabel = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.ContactsLabel
            for contact in infoArray
            {
                let sView: SpecialistInfo = contentViews[i]
                sView.specialistName.text = (contact.SpecialistName + " " + contact.SpecialistSurname)
                sView.languagesLabel.text = _languagesLabel
                sView.languageList.text = contact.AvalibleLanguages
                sView.contactsLabel.text = _contactsLabel
                sView.sckills.text = contact.Description
                i += 1
                print("ContactURL: ", contact.Contacts[1].UrlContact)
            }
        }
    }
    @objc func ShowSpecialistContact(contactButton: UIButton, contactUrl: String, contactUrlMask: String)
    {
       // contactButton = contactUrl
        //contactButton.setTitle(contactUrlMask, for: .normal)
     //contactButton.addTarget(LinkButton.OnClickLinkButtonHandler, action: #selector(LinkButton.OnClickLinkButtonHandler), for: .touchUpInside)
    }
    
    @objc func ScrollSetup()
    {
    
        scrollView.contentSize = CGSize(width: generalView.frame.width, height: generalView.frame.height)

        // Отключение горизонтальной прокрутки
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        // Установка contentInsetAdjustmentBehavior
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }

}
