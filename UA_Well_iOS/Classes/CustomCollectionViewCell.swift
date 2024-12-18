import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var MenuButton: UIButton!
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Инициализация
    }
    
    
    func copyButtonProperties(targetButton: UIButton, isFilledButton: Bool) {
        targetButton.translatesAutoresizingMaskIntoConstraints = false
        targetButton.titleLabel?.font = MenuButton.titleLabel?.font
        targetButton.translatesAutoresizingMaskIntoConstraints = MenuButton.translatesAutoresizingMaskIntoConstraints
        targetButton.layer.position = MenuButton.layer.position
        targetButton.contentMode = .center
        if isFilledButton == true
        {
            targetButton.setBackgroundImage(commoButtonBG, for: .normal)
            targetButton.setTitleColor(.white, for: .normal)
            targetButton.contentHorizontalAlignment = .center
            targetButton.titleEdgeInsets = .zero
        }
        else
        {
            targetButton.setBackgroundImage(commoButtonBG, for: .highlighted)
        }
        
        NSLayoutConstraint.activate([
            targetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            targetButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
