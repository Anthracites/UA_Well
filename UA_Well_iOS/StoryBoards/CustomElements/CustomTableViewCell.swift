import UIKit
import Foundation

class CustomTableViewCell: UITableViewCell {
    
@IBOutlet weak var MenuButton: UIButton!

override func awakeFromNib() {
    super.awakeFromNib()
    // Инициализация
}
    
    func copyButtonProperties(to targetButton: UIButton, label: String) {
        // Копируем базовые визуальные свойства
        targetButton.backgroundColor = MenuButton.backgroundColor
        targetButton.layer.cornerRadius = MenuButton.layer.cornerRadius
        targetButton.layer.borderWidth = MenuButton.layer.borderWidth
        targetButton.layer.borderColor = MenuButton.layer.borderColor
        //targetButton.contentEdgeInsets = MenuButton.contentEdgeInsets
        
        // Копируем attributedTitle, если он есть
        if let attributed = MenuButton.attributedTitle(for: .normal) {
            targetButton.setAttributedTitle(attributed, for: .normal)
        } else if 
                  let font = MenuButton.titleLabel?.font,
                  let color = MenuButton.titleColor(for: .normal) {
            // Создаём новый attributedTitle на основе обычного текста
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: color
            ]
            let attributed = NSAttributedString(string: label, attributes: attributes)
            targetButton.setAttributedTitle(attributed, for: .normal)
        }
        
        // Копируем дополнительные настройки titleLabel
        targetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        targetButton.titleLabel?.minimumScaleFactor = MenuButton.titleLabel?.minimumScaleFactor ?? 1.0
        targetButton.titleLabel?.numberOfLines = MenuButton.titleLabel?.numberOfLines ?? 1
        targetButton.titleLabel?.textAlignment = MenuButton.titleLabel?.textAlignment ?? .center
    }

}
