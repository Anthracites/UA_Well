import UIKit
import Foundation
import AVFoundation

// Доработать вью, внести bool IsLastExercise отдельно!!!
class ExerciseView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var contentView: UIView!
    var buttonLabels: [String] = ["Next", "It helped", "Contact a specialist"]
    @IBOutlet weak var exerciseText: AutoResizingTextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var imageHint: UIImageView!
    @IBOutlet weak var breathingHintWidgetButton: UIButton!
    @IBOutlet weak var hintWidget: UIView!
    var inhaleGif, exhalationGif, pauseImage: UIImage!
    var isHintActive: Bool!
    var LastExercise: Bool!
    var HelpExercisesCount: Int!
    var nextButton, itHelpedButton, contactSpecialistButton, startOverbutton: UIButton!
    var buttons = [UIButton?]()
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    var audioPlayer: AVAudioPlayer?
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    var collectionViewItemsCount: Int!
    var IsQuickHelp: Bool!

    private var stepTimer: Timer?
    private var exerciseTimer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LastExercise = IsLastExercise()
        IsQuickHelp = GetCurrentHelpType()
        GetExerices()
        SetupWidget()
        ConfigCollectionView()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        print("Hint active: ", isHintActive)

        GetImages()
        exerciseText.adjustHeight()
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView as! UIScrollView,
            contentView: contentView,
            isHintActive: isHintActive,
            exerciseText: exerciseText,
            hintWidget: hintWidget,
            collectionView: _collectionView,
            collectionViewItemsCount: collectionViewItemsCount
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
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
            let _label = TranslationDownloader.shared.CurrentTranslation.commonButtons?.ExerciseSteps[3]
            _button?.setTitle(_label, for: .normal)
            _button!.addTarget(self, action: #selector(OnHintButtonClick), for: .touchUpInside)
        }
        setupHintWidgetLayout()
    }
    
    func GetExerices()
    {
        let _type = ExerciseManager.shared.CurrentHelpType
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
    
    func GetCurrentHelpType() -> Bool
    {
        let _currentHelpType = ExerciseManager.shared.CurrentHelpType
        if _currentHelpType == "QuickHelp"
        {
            return true
        }
        else{
            return false
        }
    }
    
    func ConfigCollectionView()
    {
        if IsQuickHelp == true
        {
            if (LastExercise == true)
            {
                collectionViewItemsCount = buttonLabels.count
            }
            else {
                collectionViewItemsCount = buttonLabels.count - 1
            }
            
        }
        else
        {
            collectionViewItemsCount = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewItemsCount

    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         //_collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        let _label = buttonLabels[indexPath.item]
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        //newButoon.setBackgroundImage(commoButtonBG, for: .normal)
        buttons.append(newButoon)
        newButoon.setTitle(_label, for: .normal)
        cell.contentMode = .center
        //cell.backgroundColor = .systemBlue
        cell.adjustFontSize(for: newButoon)
        SetUpButton(ButtonIndex: indexPath.item)
        //print("Button created, index path: ", indexPath.item, "Buttons label count: ", buttonLabels.count - 2)

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
        return cell
        
    }
    
    @objc func SetUpButton(ButtonIndex: Int)
    {
        if (IsQuickHelp == true)
        {
            
            switch ButtonIndex {
            case 0:
                
                if (LastExercise == false)
                {
                    buttons[ButtonIndex]!.addTarget(self, action: #selector(NextButtonHandler), for: .touchUpInside)
                    buttons[ButtonIndex]!.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Next, for: .normal)
                    
                }
                else
                {
                    buttons[ButtonIndex]!.addTarget(self, action: #selector(StartOverButtonHandler), for: .touchUpInside)
                    buttons[ButtonIndex]!.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Start_over, for: .normal)
                }
                
            case 1:
                buttons[ButtonIndex]!.addTarget(self, action: #selector(ItHelpedButtonHandler), for: .touchUpInside)
                buttons[ButtonIndex]!.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.It_helped, for: .normal)
            case 2:
                buttons[ButtonIndex]!.addTarget(self, action: #selector(ContactSpecialistButtonHandler), for: .touchUpInside)
                buttons[ButtonIndex]!.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Contact_specialist, for: .normal)
                
            default:
                let _okButton = buttons[0]
                _okButton!.addTarget(self, action: #selector(OkButtonHandler), for: .touchUpInside)
                _okButton!.setTitle("OK", for: .normal)
            }

        }
        else
        {
            let _okButton = buttons[0]
            _okButton!.addTarget(self, action: #selector(OkButtonHandler), for: .touchUpInside)
            _okButton!.setTitle("OK", for: .normal)
        }
    }
    
    @objc func NextButtonHandler()
    {
            let nextIndex = QuickHelpManager.shared.CurrentExercise + 1
            if nextIndex < QuickHelpManager.shared.CurrentExersicesArray.count {
                QuickHelpManager.shared.CurrentExercise = nextIndex
                let storyboard = UIStoryboard(name: "ExerciseView", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "ExerciseView")
                self.present(secondVC, animated: true, completion: nil)
            } else {
                print("Попытка перейти за пределы массива упражнений")
                // Можно показать алерт или завершить серию
            }
    }
    
    @objc func ItHelpedButtonHandler()
    {
        let storyboard = UIStoryboard(name: "HelpTypesMenu", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "HelpTypesMenu")
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func OkButtonHandler()
    {
        let _name = ExerciseManager.shared.PreviousViewName

        let storyboard = UIStoryboard(name: _name!, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _name!)
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
      //  print("Exercise started!!!!", "Exercise ID", exercise.Exercise_id, " Exercise duration: ", exercise.Steps?.count)
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

        let soundFileName = "metronome"
        let currentStep = ExerciseManager.shared.CurrentStep

        guard let steps = ExerciseManager.shared.CurrentExercise.Steps,
              currentStep >= 0,
              currentStep < steps.count else {
            print("Ошибка: шаг \(currentStep) вне диапазона или Steps не инициализирован")
            imageHint.image = pauseImage
            breathingHintWidgetButton.setTitle("Старт", for: .normal)
            return
        }

        let actionIndex = steps[currentStep].action
        let hintImage: UIImage
        let hintLabels = TranslationDownloader.shared.CurrentTranslation.commonButtons?.ExerciseSteps
        let buttonLabel: String

        switch actionIndex {
        case 0:
            hintImage = inhaleGif
            buttonLabel = hintLabels?[0] ?? "inhale"
        case 1:
            hintImage = exhalationGif
            buttonLabel = hintLabels?[1] ?? "exhale"
        case 2:
            hintImage = exhalationGif
            buttonLabel = hintLabels?[2] ?? "pause"
        default:
            hintImage = pauseImage
            buttonLabel = "start"
        }

        imageHint.image = hintImage
        breathingHintWidgetButton.setTitle(buttonLabel, for: .normal)

        playSound(named: soundFileName)
    }


    
    @objc func OnHintButtonClick()
    {
        StartExercise(exercise: ExerciseManager.shared.CurrentExercise)
        print("Start button pressed!!!!")
    }
    
    @objc func SwichCurrentDay()
    {
        let _currentHelpType = ExerciseManager.shared.CurrentHelpType
        
        switch _currentHelpType {
        case "QuickHelp":
            ""
            
        case "Prevention":
            var d = UserDefaults.standard.integer(forKey: "PreventionCurrentDay")
            d += 1
            UserDefaults.standard.set(d, forKey: "PreventionCurrentDay")
            
        case "LongTimeWork":
            var d = UserDefaults.standard.integer(forKey: "LTWCurrentDay")
            d += 1
            UserDefaults.standard.set(d, forKey: "LTWCurrentDay") 
            
        default:
            ""
        }
    }
    
    func playSound(named soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else {
            print("Ошибка: файл звука \(soundFileName) не найден")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения звука: \(error.localizedDescription)")
        }
    }
    func setupHintWidgetLayout() {
        hintWidget.translatesAutoresizingMaskIntoConstraints = true

        NSLayoutConstraint.activate([
            hintWidget.widthAnchor.constraint(equalToConstant: 300/3), // или привязка к родителю
            hintWidget.heightAnchor.constraint(equalTo: hintWidget.widthAnchor)
        ])

        
        let stackView = UIStackView(arrangedSubviews: [imageHint])
            stackView.axis = .vertical
            stackView.spacing = 12
            stackView.alignment = .center
            stackView.distribution = .fill

            hintWidget.addSubview(stackView)

            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: hintWidget.topAnchor, constant: 12),
                stackView.bottomAnchor.constraint(equalTo: hintWidget.bottomAnchor, constant: -12),
                stackView.leadingAnchor.constraint(equalTo: hintWidget.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: hintWidget.trailingAnchor, constant: -16)
            ])
        
        imageHint.addSubview(breathingHintWidgetButton)

        breathingHintWidgetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breathingHintWidgetButton.centerXAnchor.constraint(equalTo: imageHint.centerXAnchor),
            breathingHintWidgetButton.centerYAnchor.constraint(equalTo: imageHint.centerYAnchor),
            breathingHintWidgetButton.widthAnchor.constraint(equalToConstant: 120),
            breathingHintWidgetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
       // imageHint.bringSubviewToFront(breathingHintWidgetButton)
        breathingHintWidgetButton.isUserInteractionEnabled = true
        imageHint.isUserInteractionEnabled = true


    }
    
    func IsLastExercise() -> Bool
    {
        let c: Int = QuickHelpManager.shared.CurrentExercise
        let a: Int = QuickHelpManager.shared.CurrentExersicesArray.count - 1
        
        let isLast = (a==c)
        print("Is Last Exercise", isLast)
        
        return isLast
    }

    }
