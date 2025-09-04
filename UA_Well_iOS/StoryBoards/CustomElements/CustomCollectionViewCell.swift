import UIKit
import Foundation


class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var MenuButton: UIButton!
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    enum ButtonDimension {
        case width(CGFloat)
        case height(CGFloat)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Инициализация
    }
    
    
    func copyButtonProperties(targetButton: UIButton, isFilledButton: Bool) {
        targetButton.translatesAutoresizingMaskIntoConstraints = false
        targetButton.titleLabel?.numberOfLines = 1
        targetButton.layer.position = MenuButton.layer.position
        targetButton.contentMode = .center

        if isFilledButton {
            adjustFontSize(for: targetButton)
            let adjustedFontSize = targetButton.titleLabel?.font.pointSize ?? 25
            targetButton.configuration = makeFilledButtonConfiguration(title: (targetButton.titleLabel?.text)!, fontSize: adjustedFontSize)
            targetButton.setTitleColor(.white, for: .normal)
            targetButton.contentHorizontalAlignment = .center
            targetButton.contentVerticalAlignment = .center
            
        } else {
            targetButton.setBackgroundImage(commoButtonBG, for: .highlighted)
        }

        NSLayoutConstraint.activate([
            targetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            targetButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }



    func calculateButtonSize(basedOn dimension: ButtonDimension, backgroundImage: UIImage, cellSpacing: CGFloat = 0) -> CGFloat
    {
        let imageSize = backgroundImage.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height

        switch dimension {
        case .width(let targetWidth):
            let scaleFactor = imageWidth / targetWidth
            return imageHeight / scaleFactor - cellSpacing

        case .height(let targetHeight):
            let scaleFactor = imageHeight / targetHeight
            return imageWidth / scaleFactor - cellSpacing
        }
    }

    
    func adjustFontSize(for button: UIButton, maxFontSize: CGFloat = 28.0, minFontSize: CGFloat = 15.0) {
        guard let titleLabel = button.titleLabel,
              let text = button.title(for: .normal),
              !text.isEmpty else { return }

        let buttonSize = button.bounds.size
        let padding: CGFloat = 16.0
        let availableWidth = buttonSize.width - padding * 2
        let availableHeight = buttonSize.height - padding * 2

        var bestFontSize = minFontSize

        for fontSize in stride(from: maxFontSize, through: minFontSize, by: -1) {
            let font = UIFont.systemFont(ofSize: fontSize)
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes,
                context: nil
            ).size

            if textSize.width <= availableWidth && textSize.height <= availableHeight {
                bestFontSize = fontSize
                break
            }
        }

        
        titleLabel.font = UIFont.systemFont(ofSize: bestFontSize)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
                
    }

    func makeFilledButtonConfiguration(title: String, fontSize: CGFloat) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.background.image = commoButtonBG

        var titleAttr = AttributedString(title)
        titleAttr.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        titleAttr.foregroundColor = .white

        config.attributedTitle = titleAttr
        return config
    
    }
    
}
