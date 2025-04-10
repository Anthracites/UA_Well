import Foundation
import UIKit

class PreventionInstruction:  UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    var previousScreenName = "PreventionScreen"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)

    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
}
