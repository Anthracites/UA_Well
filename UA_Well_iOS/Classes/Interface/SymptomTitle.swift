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
        trackAsCurrentScreen()
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
            
            let _name = "ExerciseView"
            let storyboard = UIStoryboard(name: _name, bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = nil
                window.rootViewController = nextVC
                window.makeKeyAndVisible()
            }
            
            ExerciseManager.shared.CurrentHelpType = "QuickHelp"
        }
    }
    
    @objc func BackToPreviousScreen()
    {
        let _name = _previousScreenName
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nil
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
}
