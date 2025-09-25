import Foundation
import UIKit

class PreventionInstruction:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var instructionTitleLabel: UILabel!
    @IBOutlet weak var instructionAlarmLabel: UILabel!
    @IBOutlet weak var instructionText: AutoResizingTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var PreventionAlarm:  UISwitch!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var instructionTitle: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var startExerciseButton: UIButton!
    var PreventionAlarmTime: String!
    var PreventionDuration: Int!
    var PreventionIntensity: Int!
    var PreventionCurrentDay: Int!
    var previousScreenName = "PreventionScreen"
    var currentTranslation: Translation!
    var buttonLabels: [String] = ["ExerciseView", "AboutUsAndContactUs"]
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureCollectionView()
        configureActions()
        configureLayout()
        trackAsCurrentScreen()
    }
    
    func configureCollectionView()
    {
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func configureLayout()
    {
        instructionText.adjustHeight()

let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title: instructionTitle,
            exerciseText: instructionText,
            collectionView: collectionView,
            collectionViewItemsCount: buttonLabels.count
)
        
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    func configureActions()
    {
        ExerciseManager.shared.PreviousViewName = "PreventionInstruction"
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        ExerciseManager.shared.CurrentHelpType = "Prevention"
        TranslateView()
        PreventionAlarm.addTarget(self, action: #selector(SaveOptions), for: .valueChanged)
        PreventionAlarm.isOn = UserDefaults.standard.bool(forKey: "PreventionAlarm")
        TherapyProgressTracker.shared.markTodayAsCompleted(for: .Prevention)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonLabels.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        newButoon.setTitle(buttonLabels[indexPath.item], for: .normal)
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        cell.adjustFontSize(for: newButoon)

        newButoon.tag = indexPath.item

        TranslateButton(_currentButton: newButoon)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        cell.contentMode = .center
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        
        
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
        }
        print ("Cell added. Cell title: ", buttonLabels[indexPath.item])
        
        return cell
    }
    
    @objc func TranslateView()
    {
        currentTranslation = TranslationDownloader.shared.CurrentTranslation
        backButton.setTitle(currentTranslation.commonButtons?.Return_to_parameters_title, for: .normal)
        let s = currentTranslation.prevention?.Intensivities[PreventionManager.shared.CurrentIntensity].Instruction
        instructionText.text = s
        PreventionIntensity = PreventionManager.shared.CurrentIntensity
        instructionTitleLabel.text = currentTranslation.prevention?.Intensivities[PreventionIntensity].Name
        instructionAlarmLabel.text = currentTranslation.commonButtons?.Alarm
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
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        QuickHelpManager.shared.Symtoms.sort(by: { $0.symptom_ID < $1.symptom_ID})
        ExerciseManager.shared.QuickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
        QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.QuickHelpExercises[0].help_exercise_array
        QuickHelpManager.shared.CurrentExercise = 1
        QuickHelpManager.shared.CurrentSyptom  = QuickHelpManager.shared.Symtoms[5]

        
        
        let _label = buttonLabels[_currentButton.tag]
        
        let vc = ScreenCache.shared.viewController(named: _label, storyboardName: _label)
        let nextVC = vc

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
        SaveOptions()
    }
    
    @objc func GetOptions()
    {
        PreventionIntensity = PreventionManager.shared.CurrentIntensity
        PreventionDuration = (PreventionManager.shared.CurrentDuration)
        PreventionCurrentDay = PreventionManager.shared.CurrentDay
        
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
    }
}
