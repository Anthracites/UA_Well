import Foundation
import UIKit

class LTWDayDescription:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate 
{
    var _previousScreenName = "LongTimeWork"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var alarmTitle: UILabel!
    @IBOutlet weak var LTWAlarm:  UISwitch!
    var TherapyDay: Int?
    var LTWDuration: Int?
    var LTWAlarmTime: String!
    var buttonLabels: [String] = ["ExerciseView", "AboutUsAndContactUs"]
    var currentTranslation: Translation!
    var currentLTWDay: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        SetUpButton()
        ExerciseManager.shared.CurrentHelpType = "LongTimeWork"
        currentTranslation = TranslationDownloader.shared.CurrentTranslation
        TranslateView()
        LTWAlarm.addTarget(self, action: #selector(SaveOptions), for: .valueChanged)
        LTWAlarm.isOn = UserDefaults.standard.bool(forKey: "LTWAlarm")
        SaveOptions()
        TherapyDay = LTWManager.shared.CurrentDay
        TherapyProgressTracker.shared.markTodayAsCompleted(for: .LTW)
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
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_day_selection_title, for: .normal)
    }
    
    @objc func TranslateView()
    {
        if (TherapyDay == nil)
        {        
            GetOptions()
        }

        
        titleText.text = currentTranslation.longTermWork?.TherapyDays[TherapyDay!].TherapyPartName
        descriptionText.text = currentTranslation.longTermWork?.TherapyDays[TherapyDay!].Instruction
        alarmTitle.text = currentTranslation.commonButtons?.Alarm
    }
    @objc func SetUpButton()
    {
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: _previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
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
        
        if ((TherapyDay != 0)&&(indexPath.item == 0))
        {
            newButoon.isHidden = true
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        print ("Current therapy day in LTWDayDescriprion: ", TherapyDay)
        return cell
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
        
    }
    
    @objc func GetOptions()
    {
        LTWDuration = LTWManager.shared.CurrentDuration
        TherapyDay = LTWManager.shared.CurrentDay

        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        LTWAlarmTime = formatter.string(from: currentDate)
    }
    
    @objc func SaveOptions()
    {
        GetOptions()
        
        UserDefaults.standard.set(LTWManager.shared.DayCount, forKey: "LTWCurrentDay")
        UserDefaults.standard.set(LTWAlarm.isOn, forKey: "LTWAlarm")
        UserDefaults.standard.set(LTWDuration, forKey: "LTWDuration")
        UserDefaults.standard.set(LTWAlarmTime, forKey: "LTWAlarmTime")
        print ("LTW options saved!!!")
    }
}
