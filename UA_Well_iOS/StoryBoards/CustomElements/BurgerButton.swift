import UIKit

class BurgerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        print("Burger button pressed")
        guard let viewController = self.findViewController() else {
            print("Could not find view controller")
            return
        }

        let storyboard = UIStoryboard(name: "PopUpView", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "PopUpView") as? PopUpView else {
            print("Failed to instantiate PopUpView")
            return
        }

        viewController.present(secondVC, animated: true, completion: nil)
    }

    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let next = nextResponder {
            if let viewController = next as? UIViewController {
                return viewController
            }
            nextResponder = next.next
        }
        return nil
    }
}
