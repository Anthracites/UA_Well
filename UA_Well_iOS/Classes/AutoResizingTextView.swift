import UIKit

class AutoResizingTextView: UITextView {

    private var heightConstraint: NSLayoutConstraint?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupAutoResize()
    }

    private func setupAutoResize() {
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self

        // Создаём constraint высоты, если его нет
        if heightConstraint == nil {
            let constraint = heightAnchor.constraint(equalToConstant: 0)
            constraint.priority = .defaultHigh
            constraint.isActive = true
            heightConstraint = constraint
        }

        // Обновляем высоту после layout
        DispatchQueue.main.async {
            self.adjustHeight()
        }
        print("Text setuped!!!!!")
    }

    func adjustHeight() {
        guard bounds.width > 0 else { return }
        let fittingSize = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        heightConstraint?.constant = size.height
    }
}

extension AutoResizingTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        adjustHeight()
    }
}
