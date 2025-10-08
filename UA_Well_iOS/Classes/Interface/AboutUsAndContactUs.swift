import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: AutoResizingTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var specialistsInfo: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mednaukaTextView: AutoResizingTextView!
    @IBOutlet weak var okButton: UIButton!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    
    var onClose: (() -> Void)? = nil
    var isFromPopUp:Bool = false

    @IBAction func closeTapped(_ sender: UIButton) {
        if isFromPopUp == true {
            dismiss(animated: true) { [self] in
                (onClose!)()
            }
        } else {
            let _name = ScreenCache.shared.previousVC?.nibName
            //let storyboard = UIStoryboard(name: _name!, bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = ScreenCache.shared.previousVC
                window.makeKeyAndVisible()
            }

        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        guard let _currentTranslation = TranslationDownloader.shared.CurrentTranslation else { return }

        specialistsInfo.register(UINib(nibName: "SpecialistInfo", bundle: nil), forCellWithReuseIdentifier: "SpecialistInfo")
        specialistsInfo.delegate = self
        specialistsInfo.dataSource = self
        specialistsInfo.contentMode = .center
        
        translateView(Translation: _currentTranslation)
        descriptionTextView.adjustHeight()
        
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title:titleContainerView,
            collectionView: specialistsInfo,
            collectionViewItemsCount: 2,
            collectionViewItemsHeight: 400,
            collectionViewVerticalSpacing:25,
            footer: mednaukaTextView,
            okButton: okButton
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
        
        //okButton.addTarget(self, action: #selector(backToPreviousScreen), for: .touchUpInside)
    }
    
     func translateView(Translation: Translation)
    {
        titleLabel.text = Translation.aboutUsAndcontactUs?.Title
        descriptionTextView.text = Translation.aboutUsAndcontactUs?.Description
        
        if Translation.currentLanguage == "Русский" {
            mednaukaTextView.attributedText = makeMednaukaAttributedText()
        } else {
            mednaukaTextView.text = Translation.aboutUsAndcontactUs?.MednaukaText
        }

    }
    
    func makeMednaukaAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\n\"Техники, используемые в приложении, взяты у авторов канала ")
        let linkText = NSAttributedString(string: "Mednauka", attributes: [
            .link: URL(string: "https://www.youtube.com/@mednauka")!,
            .foregroundColor: UIColor.systemRed,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        attributedText.append(linkText)
        attributedText.append(NSAttributedString(string: ". Здесь вы найдёте больше информации о психиатрии, наркологии, психотерапии и психофармакологии."))
        return attributedText
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
        cell.contacts = (TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts[indexPath.item].Contacts)!
        print("Contacts count:", cell.contacts.count)
        let index = indexPath.item
        let _translation = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs
        cell.languagesLabel.text = _translation?.LanguagesLabel
        cell.contactsLabel.text = _translation?.ContactsLabel
        if let infoArray = _translation?.SpecialistContacts {
            let contact = infoArray[index]
//            cell.contacts = contact.Contacts
            cell.photoImage = UIImage(named: contact.SpecialistPhoto)
            cell.specialistName.text = "\(contact.SpecialistName)\n\(contact.SpecialistSurname)"
            cell.languageList.text = contact.AvalibleLanguages
            cell.sckills.text = contact.Description
            cell.contacts = contact.Contacts
//            cell.FillCollectionView()
        }
//        cell.contactsView.reloadData()
        return cell

    }
}
