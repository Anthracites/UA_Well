import Foundation
import UIKit


class SymptomTitle:  UIViewController{
    
    @IBOutlet var StartButton: UIButton!
    @IBOutlet weak var _backButton: UIButton!
    var _previousScreenName = "QuickHelp"

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpButton()
    }

    @objc func SetUpButton()
    {
        StartButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Start, for: .normal)
        StartButton.addTarget(self, action: #selector(OnClickStartButton), for: .touchUpInside)
        _backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
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
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: _previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
}
