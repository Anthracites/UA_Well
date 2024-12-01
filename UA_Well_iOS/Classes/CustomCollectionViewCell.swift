import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var MenuButton: UIButton!
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
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
        targetButton.setBackgroundImage(commoButtonBG, for: .highlighted)
        
        NSLayoutConstraint.activate([
            targetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            targetButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
