import Foundation
import UIKit
class BreathingHintWidget: UIView {
    
    @IBOutlet weak var BreathButton: UIButton!
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          commonInit()
      }

      private func commonInit() {
          guard let view = loadViewFromNib() else { return }
          view.frame = self.bounds
          view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          addSubview(view)
      }

      private func loadViewFromNib() -> UIView? {
          let nib = UINib(nibName: "BreathingHintWidget", bundle: nil)
          return nib.instantiate(withOwner: self, options: nil).first as? UIView
      }

      override func awakeFromNib() {
          super.awakeFromNib()
          BreathButton.addTarget(self, action: #selector(OnClickHintButton), for: .touchUpInside)
      }

      @objc private func OnClickHintButton() {
          print("Hint button tapped!")
      }
  }
