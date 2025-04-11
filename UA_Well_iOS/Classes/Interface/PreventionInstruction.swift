import Foundation
import UIKit

class PreventionInstruction:  UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startExerciseButton: UIButton!
    var previousScreenName = "PreventionScreen"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_parameters_title, for: .normal)
        startExerciseButton.addTarget(self, action: #selector(OnClickStartButton), for: .touchUpInside)
        

    }
    
    @objc func OnClickStartButton()
    {
        QuickHelpManager.shared.Symtoms.sort(by: { $0.symptom_ID < $1.symptom_ID})
        ExerciseManager.shared.QuickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
        QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.QuickHelpExercises[0].help_exercise_array
        QuickHelpManager.shared.CurrentExercise = 1
        QuickHelpManager.shared.CurrentSyptom  = QuickHelpManager.shared.Symtoms[5]
        
        
        
        let _storyBoardName = "ExerciseView"
        
        let storyboard = UIStoryboard(name: _storyBoardName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _storyBoardName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
        
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
