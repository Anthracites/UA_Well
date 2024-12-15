import Foundation
import UIKit

class BurgerButton: UIButton
{
    var viewController:UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        setupButton()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    
    private func setupButton()
    {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        print("Burger button setuped")

    }

    

    @objc private func buttonTapped()
    {
        print("Burger button pressed")
        guard let vc = viewController else { return }

            let storyboard = UIStoryboard(name: "PopUpView", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "PopUpView")
            // Переход к новому ViewController
        vc.present(secondVC, animated: true, completion: nil)
    }
    }
