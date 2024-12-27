import UIKit

class ReturnButton : UIButton{
    public var previousScreen: UIStoryboard!
    
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
        print("Return button pressed")
        guard let viewController = self.findViewController() else {
            print("Could not find view controller")
            return
        }

        let storyboard = previousScreen
        guard let secondVC = previousScreen else {
            print("Failed to instantiate PopUpView")
            return
        }

       // viewController.present(secondVC, animated: true, completion: nil)
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

