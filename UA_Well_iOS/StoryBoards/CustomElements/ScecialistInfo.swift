import Foundation
import UIKit
import Foundation

class SpecialistInfo: UIView {
    @IBOutlet weak var sPhoto: UIImageView!
    @IBOutlet weak var specialistName: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var languageList: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var sckills: UILabel!
    @IBOutlet weak var contactsView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setupLayout()
    }

    
    @objc func setupLayout() {
        sPhoto.translatesAutoresizingMaskIntoConstraints = false
        specialistName.translatesAutoresizingMaskIntoConstraints = false
        languagesLabel.translatesAutoresizingMaskIntoConstraints = false
        languageList.translatesAutoresizingMaskIntoConstraints = false
        contactsLabel.translatesAutoresizingMaskIntoConstraints = false
        sckills.translatesAutoresizingMaskIntoConstraints = false
        contactsView.translatesAutoresizingMaskIntoConstraints = false

        sPhoto.layer.cornerRadius = 40
        sPhoto.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            sPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            sPhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            sPhoto.widthAnchor.constraint(equalToConstant: 80),
            sPhoto.heightAnchor.constraint(equalTo: sPhoto.widthAnchor),

            specialistName.topAnchor.constraint(equalTo: sPhoto.bottomAnchor, constant: 12),
            specialistName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            specialistName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            languagesLabel.topAnchor.constraint(equalTo: specialistName.bottomAnchor, constant: 8),
            languagesLabel.leadingAnchor.constraint(equalTo: specialistName.leadingAnchor),
            languagesLabel.trailingAnchor.constraint(equalTo: specialistName.trailingAnchor),

            languageList.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 4),
            languageList.leadingAnchor.constraint(equalTo: specialistName.leadingAnchor),
            languageList.trailingAnchor.constraint(equalTo: specialistName.trailingAnchor),

            sckills.topAnchor.constraint(equalTo: languageList.bottomAnchor, constant: 8),
            sckills.leadingAnchor.constraint(equalTo: specialistName.leadingAnchor),
            sckills.trailingAnchor.constraint(equalTo: specialistName.trailingAnchor),

            contactsLabel.topAnchor.constraint(equalTo: sckills.bottomAnchor, constant: 12),
            contactsLabel.leadingAnchor.constraint(equalTo: specialistName.leadingAnchor),
            contactsLabel.trailingAnchor.constraint(equalTo: specialistName.trailingAnchor),

            contactsView.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 8),
            contactsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactsView.heightAnchor.constraint(equalToConstant: 44),

            contactsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }

}
