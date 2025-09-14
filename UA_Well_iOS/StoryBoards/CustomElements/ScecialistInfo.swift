import Foundation
import UIKit
import Foundation

class SpecialistInfo: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var sPhoto: UIImageView!
    @IBOutlet weak var specialistName: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var languageList: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var sckills: UILabel!
    @IBOutlet weak var contactsView: UICollectionView!
    @IBOutlet weak var generalview: UIView!
    var collectionViewCell: UICollectionViewCell!
    var contacts: [Translation.AboutUsAndContactUs.SpecialistContact.Contact] = []
    
    var photoImage: UIImage? {
            didSet {
                sPhoto.image = photoImage
                setupLayout()
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactsView.register(UINib(nibName: "ContactCell", bundle: nil), forCellWithReuseIdentifier: "ContactCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCell
                   let index = collectionView.tag
        if contacts != nil {
            _cell.contactButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10)

                       let contact = contacts[indexPath.item]
                       _cell.linkURL = contact.UrlContact
                       _cell.mailTitle = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailTitle
                       _cell.mailBody = TranslationDownloader.shared.CurrentTranslation.aboutUsAndcontactUs?.EmailBody
                       //_cell.contactButton.setTitle(contact.UrlMask, for: .normal)
            _cell.contactButton.configuration = MakeContactButtonConfiguration(title: contact.UrlMask, fontSize: 15)
                       _cell.contactButton.addTarget(ContactCell.OnClickLinkButtonHandler, action: #selector(ContactCell.OnClickLinkButtonHandler), for: .touchUpInside)
                       _cell.contentMode = .center
                       if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                           layout.scrollDirection = .horizontal
                           layout.itemSize = CGSize(width: 75, height: 50)
                       }
                   }
                   return _cell
    }
    func MakeContactButtonConfiguration(title: String, fontSize: CGFloat) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero

        var titleAttr = AttributedString(title)
        titleAttr.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        titleAttr.foregroundColor = .white

        config.attributedTitle = titleAttr
        return config
    
    }
    
    @objc func FillCollectionView()
    {
        contactsView.delegate = self
        contactsView.dataSource = self
    }
    
    @objc func setupLayout() {
        //sPhoto.contentMode = .scaleAspectFill
        //sPhoto.clipsToBounds = true
        sPhoto.translatesAutoresizingMaskIntoConstraints = false
        specialistName.translatesAutoresizingMaskIntoConstraints = false
        languagesLabel.translatesAutoresizingMaskIntoConstraints = false
        languageList.translatesAutoresizingMaskIntoConstraints = false
        contactsLabel.translatesAutoresizingMaskIntoConstraints = false
        sckills.translatesAutoresizingMaskIntoConstraints = false
        contactsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            generalview.topAnchor .constraint(equalTo: self.topAnchor, constant: 0),
            sPhoto.topAnchor.constraint(equalTo: generalview.topAnchor, constant: 16),
            sPhoto.heightAnchor.constraint(equalToConstant: 144),
            sPhoto.widthAnchor.constraint(equalToConstant: 144),

               specialistName.centerYAnchor.constraint(equalTo: sPhoto.centerYAnchor),
            //specialistName.centerXAnchor.constraint(equalTo: sPhoto.centerXAnchor),
               specialistName.leadingAnchor.constraint(equalTo: sPhoto.trailingAnchor, constant: 12),
            specialistName.heightAnchor.constraint(equalTo: sPhoto.heightAnchor, constant: 0),

            
//            specialistName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            languagesLabel.topAnchor.constraint(equalTo: sPhoto.bottomAnchor, constant: 5),
            languagesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            languagesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            languagesLabel.heightAnchor.constraint(equalToConstant: 25),


            languageList.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 0),
            languageList.leadingAnchor.constraint(equalTo: leadingAnchor),
            languageList.trailingAnchor.constraint(equalTo: trailingAnchor),
            languageList.heightAnchor.constraint(equalToConstant: 25),
            
            contactsLabel.topAnchor.constraint(equalTo: languageList.bottomAnchor, constant: 20),
            contactsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactsLabel.heightAnchor.constraint(equalToConstant: 25),

            contactsView.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 0),
            contactsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactsView.heightAnchor.constraint(equalToConstant: 44),
            
            sckills.topAnchor.constraint(equalTo: contactsView.bottomAnchor, constant: 0),
            sckills.leadingAnchor.constraint(equalTo: leadingAnchor),
            sckills.trailingAnchor.constraint(equalTo: trailingAnchor),
            sckills.heightAnchor.constraint(equalToConstant: 44),

            
            sckills.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            generalview.bottomAnchor.constraint(equalTo: sckills.bottomAnchor, constant: 0)
        ])
    }

}
