import Foundation
import UIKit

class PreventionInstruction:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    @IBOutlet weak var backButton: UIButton!
    var startExerciseButton: UIButton!
    @IBOutlet weak var instructionTitle: UILabel!
    @IBOutlet weak var instructionText: UITextView!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var PreventionAlarm:  UISwitch!
    var PreventionAlarmTime: String!
    var PreventionDuration: Int!
    var PreventionIntensity: Int!
    var PreventionCurrentDay: Int!
    var previousScreenName = "PreventionScreen"
    var currentTranslation: Translation!
    var buttonLabels: [String] = ["ExerciseView", "AboutUsAndContactUs"]

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        ExerciseManager.shared.CurrentHelpType = "Prevention"
        TranslateView()
        PreventionCurrentDay = 0
        PreventionAlarm.addTarget(self, action: #selector(SaveOptions), for: .valueChanged)
        PreventionAlarm.isOn = UserDefaults.standard.bool(forKey: "PreventionAlarm")
        SaveOptions()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonLabels.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        newButoon.tag = indexPath.item
        newButoon.setTitle(buttonLabels[indexPath.item], for: .normal)

        TranslateButton(_currentButton: newButoon)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        cell.contentMode = .center
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        print ("Cell added. Cell index: ", indexPath.item)
        return cell
    }
    
    @objc func TranslateView()
    {
        currentTranslation = TranslationDownloader.shared.CurrentTranslation
        backButton.setTitle(currentTranslation.commonButtons?.Return_to_parameters_title, for: .normal)
        let s = currentTranslation.prevention?.Intensivities[PreventionManager.shared.CurrentSensity].Instruction
        instructionText.text = s
        PreventionIntensity = PreventionManager.shared.CurrentSensity
        instructionTitle.text = currentTranslation.prevention?.Intensivities[PreventionIntensity].Name
    }
    
    func TranslateButton(_currentButton: UIButton)
    {
       // StartButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Start, for: .normal)
        let _label = _currentButton.titleLabel?.text
        let _translatedLabel: String
        
        switch _label {
        case "ExerciseView":
            _translatedLabel = currentTranslation.commonButtons!.Start
        case "AboutUsAndContactUs":
            _translatedLabel = currentTranslation.commonButtons!.Contact_specialist

        default:
            _translatedLabel = "Ok"
        }
        
        _currentButton.setTitle(_translatedLabel, for: .normal)
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        QuickHelpManager.shared.Symtoms.sort(by: { $0.symptom_ID < $1.symptom_ID})
        ExerciseManager.shared.QuickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
        QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.QuickHelpExercises[0].help_exercise_array
        QuickHelpManager.shared.CurrentExercise = 1
        QuickHelpManager.shared.CurrentSyptom  = QuickHelpManager.shared.Symtoms[5]

        
        
        let _storyBoardName = buttonLabels[_currentButton.tag]
        
        let storyboard = UIStoryboard(name: _storyBoardName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _storyBoardName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
        SaveOptions()
    }
    
    @objc func GetOptions()
    {
        PreventionIntensity = PreventionManager.shared.CurrentSensity
        PreventionDuration = PreventionManager.shared.CurrentDuration
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        PreventionAlarmTime = formatter.string(from: currentDate)
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func SaveOptions()
    {
        GetOptions()
        UserDefaults.standard.set(PreventionAlarm.isOn, forKey: "PreventionAlarm")
        UserDefaults.standard.set(PreventionAlarmTime, forKey: "PreventionAlarmTime")
        UserDefaults.standard.set(PreventionDuration, forKey: "PreventionDuration")
        UserDefaults.standard.set(PreventionIntensity, forKey: "PreventionIntensity")
        UserDefaults.standard.set(PreventionCurrentDay, forKey: "PreventionCurrentDay") // Для уведомлений
        print("Options saved for prevention. Time: \(PreventionAlarmTime)")
    }
}
