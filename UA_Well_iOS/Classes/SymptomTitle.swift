import Foundation
import UIKit


class SymptomTitle:  UIViewController{
    
    @IBOutlet var StartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        StartButton.addTarget(self, action: #selector(OnClickStartButton), for: .touchUpInside)
    }

    
    @objc func OnClickStartButton(_currentButton: UIButton)
    {
        if let _label = _currentButton.titleLabel?.text
        {
            print(String(_label))
            let storyboard = UIStoryboard(name: "ExerciseView", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "ExerciseView")
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
}
