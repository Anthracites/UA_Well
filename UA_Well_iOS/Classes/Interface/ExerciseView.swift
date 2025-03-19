import UIKit
import Foundation

class ExerciseView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    var buttonLabels: [String] = ["Next", "It helped", "Contact a specialist"]
    @IBOutlet weak var exerciseText: UITextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var imageHint: UIImageView!
    @IBOutlet weak var breathingHintWidgetButton: UIButton!
    @IBOutlet weak var hintWidget: UIView!
    var inhaleGif, exhalationGif, pauseImage: UIImage!
    var isHintActive: Bool!
    var HelpExercisesCount: Int!
    var nextButton, itHelpedButton, contactSpecialistButton, startOverbutton: UIButton!
    var buttons = [UIButton?]()
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    private var stepTimer: Timer?
    private var exerciseTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetExerices()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        
        SetupWidget()
        GetImages()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonLabels.count
    }
    
    func GetImages()
    {
        pauseImage = imageHint.image
        inhaleGif = UIImage.gifImageWithName("BreathWidget", speed: 1)
        exhalationGif = UIImage.gifImageWithName("BreathWidget_r", speed: 1)
    }
    
    func SetupWidget()
    {
        hintWidget.isHidden = !isHintActive
        if (isHintActive == true)
        {
            let _button = breathingHintWidgetButton
            print("Button name: ", _button?.titleLabel?.text as Any)
            _button!.addTarget(self, action: #selector(OnHintButtonClick), for: .touchUpInside)
        }
        print ("Hint active: ", String(isHintActive))
    }
    
    func GetExerices()
    {
        let i: Int = QuickHelpManager.shared.CurrentExercise // индекс упражнения в текущем массиве
        let o: Int = QuickHelpManager.shared.CurrentExersicesArray[i] // индекс текущего упражения в массиве
        let _text = String(TranslationDownloader.shared.CurrentTranslation.Exercises[o].description)
        HelpExercisesCount = Int(QuickHelpManager.shared.CurrentExercise)
        exerciseText.text = _text
        isHintActive = ExerciseManager.shared.Exercises[o].Visual_hint
        ExerciseManager.shared.CurrentExercise = ExerciseManager.shared.Exercises[o]
        if (isHintActive == true)
        {
            ExerciseManager.shared.CurrentStep = 0
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        let HelpType = buttonLabels[indexPath.item]
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        newButoon.setBackgroundImage(commoButtonBG, for: .normal)
        buttons.append(newButoon)
        newButoon.setTitle(HelpType, for: .normal)
        cell.contentMode = .center
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        //print("Buttons count: " + String(buttons.count))
        if indexPath.item == buttonLabels.count - 1 {
            SetUpButtons()
        }
        return cell
    }
    
    @objc func SetUpButtons()
    {
        let c: Int = QuickHelpManager.shared.CurrentExercise
        let a: Int = QuickHelpManager.shared.CurrentExersicesArray.count - 1
        let _nextStartOverButton: UIButton = buttons[0]!
        let _itHelpedButtton: UIButton = buttons[1]!
        let _contactUsButton: UIButton = buttons[2]!
        
        if (a != c)
        {
            _nextStartOverButton.addTarget(self, action: #selector(NextButtonHandler), for: .touchUpInside)
            _nextStartOverButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Next, for: .normal)
        }
        else
        {
            _nextStartOverButton.addTarget(self, action: #selector(StartOverButtonHandler), for: .touchUpInside)
            _nextStartOverButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Start_over, for: .normal)
        }
        
        _itHelpedButtton.addTarget(self, action: #selector(ItHelpedButtonHandler), for: .touchUpInside)
        _itHelpedButtton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.It_helped, for: .normal)
        
        _contactUsButton.addTarget(self, action: #selector(ContactSpecialistButtonHandler), for: .touchUpInside)
        _contactUsButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Contact_specialist, for: .normal)
        
    }
    
    @objc func NextButtonHandler()
    {
        QuickHelpManager.shared.CurrentExercise += 1
        let storyboard = UIStoryboard(name: "ExerciseView", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "ExerciseView")
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
        
    }
    
    @objc func ItHelpedButtonHandler()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Main")
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func ContactSpecialistButtonHandler()
    {
        let storyboard = UIStoryboard(name: "AboutUsAndContactUs", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "AboutUsAndContactUs")
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func StartOverButtonHandler()
    {
        QuickHelpManager.shared.CurrentExercise = 0
        let storyboard = UIStoryboard(name: "ExerciseView", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "ExerciseView")
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stepTimer?.invalidate()
        exerciseTimer?.invalidate()
        ExerciseManager.shared.CurrentStep = 0

    }
    
    // Ебучий виджет, который придется копипастить, так как эта блядина, выведенная в отдельный класс, не завелась!!!!!
    
    
    func StartExercise(exercise: Exercise) {

        _ = exercise
        _ = ExerciseManager.shared.CurrentStep
            
            // Запуск таймера для упражнения
            exerciseTimer = Timer.scheduledTimer(timeInterval: TimeInterval(exercise.ExerciseDuration ?? 0), target: self, selector: #selector(restartExercise), userInfo: nil, repeats: false)
        
            startStepTimer()
        updateHintState()
        print("Exercise started!!!!", "Exercise ID", exercise.Exercise_id, " Exercise duration: ", exercise.Steps?.count)
        }
        
        private func startStepTimer() {
            
            let _currentStep = ExerciseManager.shared.CurrentStep
            guard let _steps = ExerciseManager.shared.CurrentExercise.Steps, _steps.count > _currentStep else { return }
            
            let _stepDuration = TimeInterval(_steps[_currentStep].duration)
            if (isHintActive == true)
            {
                stepTimer = Timer.scheduledTimer(timeInterval: _stepDuration, target: self, selector: #selector(nextStep), userInfo: nil, repeats: false)
            }
        }
        
        @objc private func nextStep() {
            ExerciseManager.shared.CurrentStep += 1
            
            if ExerciseManager.shared.CurrentStep >= ExerciseManager.shared.CurrentExercise.Steps!.count {
                ExerciseManager.shared.CurrentStep = 0 // Сброс шага, если достигнут конец
            }
            
            // Запуск таймера для следующего шага
            startStepTimer()
            
            // Обновление состояния визуальной подсказки
            updateHintState()
        }
        
        @objc private func restartExercise() {
            ExerciseManager.shared.CurrentStep = 0
            startStepTimer()
            
            // Перезапуск таймера для упражнения
            exerciseTimer?.invalidate()
            exerciseTimer = Timer.scheduledTimer(timeInterval: TimeInterval(ExerciseManager.shared.CurrentExercise.ExerciseDuration ?? 0), target: self, selector: #selector(restartExercise), userInfo: nil, repeats: false)
        }
        
        func stopExercise() {
            stepTimer?.invalidate()
            exerciseTimer?.invalidate()
        }
        
        // Метод для обновления состояния визуальной подсказки
        @objc func updateHintState() {
            print("Exercise started!")

            let _buttonLabel: String
            let i: Int = ExerciseManager.shared.CurrentStep
            let _actionIndex = ExerciseManager.shared.CurrentExercise.Steps![i].action
            let _hintImage: UIImage
            
            switch _actionIndex {
            case 0:
                _hintImage = inhaleGif
                _buttonLabel = "Вдох"
            case 1:
                _hintImage = exhalationGif
                _buttonLabel = "Выдох"
            case 2:
                _hintImage = exhalationGif
                _buttonLabel = "Пауза"

            default:
                _buttonLabel = "Старт"
                _hintImage = pauseImage
            }

            imageHint.image = _hintImage
            breathingHintWidgetButton.setTitle(_buttonLabel, for: .normal)
        }
    
    @objc func OnHintButtonClick()
    {
        StartExercise(exercise: ExerciseManager.shared.CurrentExercise)
        //updateHintState()
        //ExerciseManager.shared.CurrentStep += 1
    }

    
    }
