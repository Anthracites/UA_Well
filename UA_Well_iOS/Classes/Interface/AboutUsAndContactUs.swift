import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentViews: [SpecialistInfo]!
    @IBOutlet var generalView: UIView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewDescription: UITextView!
    
        // Ваши свойства и методы
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
        @objc func AddSpecialistInfo() {
            if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts {
                var i: Int = 0
                let _languagesLabel = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.LanguagesLabel
                let _contactsLabel = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.ContactsLabel

                for contact in infoArray {
                    let sView: SpecialistInfo = contentViews[i]
                    sView.specialistName.text = "\(contact.SpecialistName) \(contact.SpecialistSurname)"
                    sView.languagesLabel.text = _languagesLabel
                    sView.languageList.text = contact.AvalibleLanguages
                    sView.contactsLabel.text = _contactsLabel
                    sView.sckills.text = contact.Description
                    let _contactView: UICollectionView = sView.contactsView
                    _contactView.register(UINib(nibName: "ContactCell", bundle: nil), forCellWithReuseIdentifier: "ContactCell")
                    _contactView.contentMode = .center

                    // Устанавливаем делегаты и источник данных
                    _contactView.dataSource = self
                    _contactView.delegate = self

                    // Сохраняем текущий индекс
                    _contactView.tag = i

                    i += 1
                }
            }
        }

        // MARK: - UICollectionViewDataSource

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // Используем индекс, сохраненный в tag для получения информации о количестве контактов
            let index = collectionView.tag
            if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts {
                return infoArray[index].Contacts.count
            }
            return 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCell
            let index = collectionView.tag
            if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts {
                let contact = infoArray[index].Contacts[indexPath.item]
                cell.linkURL = contact.UrlContact
                cell.mailTitle = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailTitle
                cell.mailBody = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailBody
                //cell.cellViewController = self
                cell.contactButton.setTitle(contact.UrlMask, for: .normal)
                cell.contactButton.addTarget(ContactCell.OnClickLinkButtonHandler, action: #selector(ContactCell.OnClickLinkButtonHandler), for: .touchUpInside)
                cell.contentMode = .center
                cell.backgroundColor = .black
                cell.contactButton.backgroundColor = .blue
                
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.itemSize = CGSize(width: 50, height: 50)
                }

                //cell.configure(with: contact.UrlContact) // Предполагаем, что UrlContact - это строка
            }
            return cell
        }

        // MARK: - UICollectionViewDelegate

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Обработка выбора ячейки
            let index = collectionView.tag
            if let infoArray = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.SpecialistContacts {
                let contact = infoArray[index].Contacts[indexPath.item]
                print("Вы выбрали контакт: \(contact.UrlContact)")
            }
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
