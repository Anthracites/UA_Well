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
        targetButton.titleLabel?.numberOfLines = 1
        targetButton.translatesAutoresizingMaskIntoConstraints = MenuButton.translatesAutoresizingMaskIntoConstraints
        targetButton.layer.position = MenuButton.layer.position
        targetButton.contentMode = .center
        if isFilledButton == true
        {
            targetButton.setBackgroundImage(commoButtonBG, for: .normal)
            targetButton.setTitleColor(.white, for: .normal)
            targetButton.contentHorizontalAlignment = .center
            //targetButton.titleEdgeInsets = .zero
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
    
    
    func calculateButtonHeight(for buttonWidth: CGFloat, backgroundImage: UIImage, cellSpacing: CGFloat) -> CGFloat {
        let imageHeight = backgroundImage.size.height
        let imageWidth = backgroundImage.size.width
        let scaleFactor = imageWidth / buttonWidth
        return imageHeight / scaleFactor - cellSpacing
    }
    
    func adjustFontSize(for button: UIButton, maxFontSize: CGFloat = 28.0, minFontSize: CGFloat = 14.0) {
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


    
}
