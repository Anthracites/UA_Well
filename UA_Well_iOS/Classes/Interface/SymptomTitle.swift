import Foundation
import UIKit


class SymptomTitle:  UIViewController{
    
    @IBOutlet var StartButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var SymptomLabel: UILabel!
    @IBOutlet var symptomDescrioption: AutoResizingTextView!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    var _previousScreenName = "QuickHelp"


    

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpButton()
        GetTextes()
        configureLayout()
    }
    func configureLayout()
    {
        symptomDescrioption.adjustHeight()
        
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title:SymptomLabel,
            exerciseText: symptomDescrioption,
            okButton: StartButton
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
        SymptomLabel.adjustsFontSizeToFitWidth = true
    }
    
    @objc func GetTextes()
    {
        SymptomLabel.text = QuickHelpManager.shared.CurrentSyptom.symptom_name
        symptomDescrioption.text = QuickHelpManager.shared.CurrentSyptom.symptom_description
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_symptoms_title, for: .normal)
    }
    
    @objc func SetUpButton()
    {
        StartButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Start, for: .normal)
        StartButton.addTarget(self, action: #selector(OnClickStartButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
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
            ExerciseManager.shared.CurrentHelpType = "QuickHelp"
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
