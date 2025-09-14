import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var viewDescription: AutoResizingTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var specialistsInfo: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textMednaukaRu: AutoResizingTextView!
    @IBOutlet weak var okButton: UIButton!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        specialistsInfo.register(UINib(nibName: "SpecialistInfo", bundle: nil), forCellWithReuseIdentifier: "SpecialistInfo")
        specialistsInfo.delegate = self
        specialistsInfo.dataSource = self
        specialistsInfo.contentMode = .center

        TranslateView()
        SetupLink()
        viewDescription.adjustHeight()
        
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title:viewTitle,
            collectionView: specialistsInfo,
            collectionViewItemsCount: 2,
            collectionViewItemsHeight: 400,
            collectionViewVerticalSpacing:25,
            footer: textMednaukaRu,
            okButton: okButton
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
        
        okButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
    }
    
    @objc func TranslateView()
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        viewTitleLabel.text = _translation?.aboutUsAndcontactUs?.Title
        viewDescription.text = _translation?.aboutUsAndcontactUs?.Description
    }
    func SetupLink()
    {
        if TranslationDownloader.shared.CurrentTranslation.currentLanguage == "Русский" {
            let attributedText = NSMutableAttributedString(string: "\n\"Техники, используемые в приложении, взяты у авторов канала ")
            
            let linkText = NSAttributedString(string: "Mednauka", attributes: [
                .link: URL(string: "https://www.youtube.com/@mednauka")!,
                .foregroundColor: UIColor.systemRed,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
            
            attributedText.append(linkText)
            attributedText.append(NSAttributedString(string: ". Здесь вы найдёте больше информации о психиатрии, наркологии, психотерапии и психофармакологии."))
            
            textMednaukaRu.attributedText = attributedText
            textMednaukaRu.isEditable = false
            textMednaukaRu.isSelectable = true
            textMednaukaRu.dataDetectorTypes = []
            textMednaukaRu.textAlignment = .left
        }
        else {
            textMednaukaRu.text = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.MednaukaText
        }

    }
    
    // MARK: - UICollectionViewDataSource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts {
            return infoArray[index].Contacts.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialistInfo", for: indexPath) as! SpecialistInfo
        let index = indexPath.item
        let _translation = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs
        cell.languagesLabel.text = _translation?.LanguagesLabel
        cell.contactsLabel.text = _translation?.ContactsLabel
        if let infoArray = _translation?.SpecialistContacts {
            let contact = infoArray[index]
            cell.contacts = contact.Contacts
            let sView: SpecialistInfo = SpecialistInfo()
            sView.backgroundColor = .cyan
            cell.photoImage = UIImage(named: contact.SpecialistPhoto)
            cell.specialistName.text = "\(contact.SpecialistName)\n\(contact.SpecialistSurname)"
            cell.languageList.text = contact.AvalibleLanguages
            cell.sckills.text = contact.Description
            cell.contacts = contact.Contacts
            cell.FillCollectionView()
        }
        
        
        return cell

    }


    
    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }

}
