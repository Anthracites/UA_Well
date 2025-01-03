import Foundation
import UIKit

class CustomDropDown: UICollectionViewCell {
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var dropDown: UIButton!
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        func copyDDProperties(targetButton: UIButton) {
            targetButton.translatesAutoresizingMaskIntoConstraints = false
            targetButton.titleLabel?.font = dropDown.titleLabel?.font
            
            targetButton.translatesAutoresizingMaskIntoConstraints = dropDown.translatesAutoresizingMaskIntoConstraints
            targetButton.layer.position = dropDown.layer.position
            targetButton.contentMode = .center


            
            NSLayoutConstraint.activate([
                targetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                targetButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
}
