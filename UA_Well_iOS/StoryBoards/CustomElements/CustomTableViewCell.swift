import UIKit
import Foundation

class CustomTableViewCell: UITableViewCell {
    
@IBOutlet weak var MenuButton: UIButton!

override func awakeFromNib() {
    super.awakeFromNib()
    // Инициализация
}
    
    func copyButtonProperties(targetButton: UIButton) {
        targetButton.translatesAutoresizingMaskIntoConstraints = false
        targetButton.titleLabel?.font = MenuButton.titleLabel?.font        
        targetButton.translatesAutoresizingMaskIntoConstraints = MenuButton.translatesAutoresizingMaskIntoConstraints
        targetButton.layer.position = MenuButton.layer.position
        targetButton.contentMode = .center


        
        NSLayoutConstraint.activate([
            targetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            targetButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
