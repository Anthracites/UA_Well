import Foundation
import UIKit

class CustomDropDown: UICollectionViewCell {
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var dropDown: UIButton!
    public var CurrentOption: Int!
    
    
        override func awakeFromNib() {
            super.awakeFromNib()
            CurrentOption = 0
        }
    

        func copyDDProperties(targetButton: UIButton) {
            targetButton.translatesAutoresizingMaskIntoConstraints = false
            targetButton.titleLabel?.font = dropDown.titleLabel?.font
            
            targetButton.translatesAutoresizingMaskIntoConstraints = dropDown.translatesAutoresizingMaskIntoConstraints
            targetButton.layer.position = dropDown.layer.position
            targetButton.contentMode = .bottom
            
                        ddLabel.font = UIFont.systemFont(ofSize: 14)
            ddLabel.textAlignment = .left
                        ddLabel.translatesAutoresizingMaskIntoConstraints = false
            //ddLabel.backgroundColor = .darkGray
            
            targetButton.translatesAutoresizingMaskIntoConstraints = false
            targetButton.layer.cornerRadius = 8
            targetButton.clipsToBounds = true
            
            ddLabel.translatesAutoresizingMaskIntoConstraints = false
            targetButton.translatesAutoresizingMaskIntoConstraints = false

            ddLabel.translatesAutoresizingMaskIntoConstraints = false
            dropDown.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                ddLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                ddLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                ddLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

                dropDown.topAnchor.constraint(equalTo: ddLabel.bottomAnchor, constant: 8),
                dropDown.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                dropDown.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                dropDown.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])


        }
    
    func SetupPullDownMenu(DropDown: UIButton, DropDownItems: [String]) {
        let menu = UIMenu(title: "", children: DropDownItems.enumerated().map { index, option in
            UIAction(title: option, identifier: UIAction.Identifier("\(index)"), handler: { action in
                print("Выбранный элемент: \(option), индекс: \(index)")
                self.CurrentOption = index
                DropDown.setTitle(option, for: .normal)
            })
        })
        DropDown.menu = menu
        DropDown.showsMenuAsPrimaryAction = true
        copyDDProperties(targetButton: DropDown)
    }
}
