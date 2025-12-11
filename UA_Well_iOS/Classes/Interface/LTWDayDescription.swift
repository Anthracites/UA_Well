import Foundation
import UIKit

class LTWDayDescription:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate 
{
    var _previousScreenName = "LongTimeWork"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: AutoResizingTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var alarmTitle: UILabel!
    @IBOutlet weak var LTWAlarm:  UISwitch!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dayTitle: UIView!
    var TherapyDay: Int?
    var LTWDuration: Int?
    var LTWAlarmTime: String!
    var buttonLabels: [String] = ["ExerciseView", "AboutUsAndContactUs"]
    var currentTranslation: Translation!
    var currentLTWDay: Int!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureActions()
        configCollectionView()
        SetUpButton()
        ExerciseManager.shared.CurrentHelpType = "LongTimeWork"
        currentTranslation = TranslationDownloader.shared.CurrentTranslation
        TranslateView()
        LTWAlarm.addTarget(self, action: #selector(SaveOptions), for: .valueChanged)
        LTWAlarm.isOn = UserDefaults.standard.bool(forKey: "LTWAlarm")
        SaveOptions()
        TherapyProgressTracker.shared.markTodayAsCompleted(for: .LTW)
        configureLayout()
        trackAsCurrentScreen()
    }

    func configureLayout()
    {
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title:dayTitle,
            exerciseText: descriptionText,
            collectionView: _collectionView,
            collectionViewItemsCount: buttonLabels.count
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    func configureActions()
    {
        TherapyDay = LTWManager.shared.CurrentDay

    }
    
    func TranslateButton(_currentButton: UIButton)
    {
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
        let _name = _previousScreenName
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
        func configCollectionView()
    {
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        
        if (TherapyDay != 0)
        {
            buttonLabels = ["AboutUsAndContactUs"]
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return buttonLabels.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        newButoon.tag = indexPath.item
        newButoon.setTitle(buttonLabels[indexPath.item], for: .normal)
        TranslateButton(_currentButton: newButoon)
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        cell.adjustFontSize(for: newButoon)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        
        cell.contentMode = .center

        
        if let backgroundImage = newButoon.backgroundImage(for: .normal) {
            
            // Задаём фиксированную высоту кнопки
            let targetHeight: CGFloat = UIScreen.main.bounds.width < 400 ? 80 : 120
            let buttonHeight = targetHeight

            // Вычисляем ширину кнопки по высоте
            let rawWidth = cell.calculateButtonSize(basedOn: .height(buttonHeight), backgroundImage: backgroundImage, cellSpacing: 16)

            // Ограничиваем максимальную ширину
            let horizontalInset: CGFloat = 32 // например, 16 слева и 16 справа
            let maxWidth = collectionView.frame.width - horizontalInset
            let buttonWidth = min(rawWidth, maxWidth)

            // Применяем размеры к кнопке
            newButoon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newButoon.widthAnchor.constraint(equalToConstant: buttonWidth * 0.75),
                newButoon.heightAnchor.constraint(equalToConstant: buttonHeight/3)
            ])
            print("Button size:", buttonWidth * 0.75, buttonHeight/3)

        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        QuickHelpManager.shared.Symtoms.sort(by: { $0.symptom_ID < $1.symptom_ID})
        ExerciseManager.shared.QuickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
        QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.QuickHelpExercises[0].help_exercise_array
        QuickHelpManager.shared.CurrentExercise = 1
        QuickHelpManager.shared.CurrentSyptom  = QuickHelpManager.shared.Symtoms[5]
        
        
        
        let _name = buttonLabels[_currentButton.tag]
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
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
        NotificationManager.shared.scheduleNotifications()

    }
}
