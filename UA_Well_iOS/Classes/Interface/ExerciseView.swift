import UIKit
import Foundation
import AVFoundation

class ExerciseView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var viewTitle: UIView!
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
        configureExercise()
        configureCollectionView()
        SetupWidget()
        GetImages()
        configureLayout()
        trackAsCurrentScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }

    
   func configureLayout()
    {
        exerciseText.adjustHeight()
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView as! UIScrollView,
            contentView: contentView,
            title: viewTitle,
            isHintActive: isHintActive,
            exerciseText: exerciseText,
            hintWidget: hintWidget,
            collectionView: _collectionView,
            collectionViewItemsCount: collectionViewItemsCount
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    
    func configureCollectionView()
    {
        ConfigCollectionView()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self

    }
    
    func  configureExercise()
    {
        LastExercise = IsLastExercise()
        IsQuickHelp = GetCurrentHelpType()
        GetExerices()
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
            viewTitle.isHidden = true
            viewTitle = nil
            return true
        }
        else{
            header = nil
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        let _label = buttonLabels[indexPath.item]
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        buttons.append(newButoon)
        newButoon.setTitle(_label, for: .normal)
        cell.contentMode = .center
        cell.adjustFontSize(for: newButoon)
        SetUpButton(ButtonIndex: indexPath.item)

        if let backgroundImage = newButoon.backgroundImage(for: .normal) {
            
            // Задаём фиксированную высоту кнопки
            NSLayoutConstraint.activate([
                newButoon.heightAnchor.constraint(equalToConstant: 40),
                newButoon.widthAnchor.constraint(equalToConstant: 189),
            ])
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
        stopExercise()
        
            let nextIndex = QuickHelpManager.shared.CurrentExercise + 1
            if nextIndex < QuickHelpManager.shared.CurrentExersicesArray.count {
                QuickHelpManager.shared.CurrentExercise = nextIndex
                
                let _name = "ExerciseView"
                let storyboard = UIStoryboard(name: _name, bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = nextVC
                    window.makeKeyAndVisible()
                }
            }
    }
    
    @objc func ItHelpedButtonHandler()
    {
        stopExercise()
        
        let _name = "HelpTypesMenu"
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
    @objc func OkButtonHandler()
    {
        stopExercise()
        
        let _name = ExerciseManager.shared.PreviousViewName
        let storyboard = UIStoryboard(name: _name!, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name!)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
    @objc func ContactSpecialistButtonHandler()
    {
        stopExercise()
        
        let _name = "AboutUsAndContactUs"
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
        
    }
    
    @objc func StartOverButtonHandler()
    {
        stopExercise() 
        QuickHelpManager.shared.CurrentExercise = 0
        
        let _name = "ExerciseView"
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stepTimer?.invalidate()
        exerciseTimer?.invalidate()
        ExerciseManager.shared.CurrentStep = 0

    }
    
    
    
    func StartExercise(exercise: Exercise) {

        _ = exercise
        _ = ExerciseManager.shared.CurrentStep
            
        exerciseTimer?.invalidate()
        exerciseTimer = nil
        
        let duration = TimeInterval(exercise.ExerciseDuration ?? 0)
         exerciseTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
             self?.restartExercise()
         }
        
            startStepTimer()
        updateHintState()
        }
        
    private func startStepTimer() {
        let currentStep = ExerciseManager.shared.CurrentStep
        guard let steps = ExerciseManager.shared.CurrentExercise.Steps,
              steps.indices.contains(currentStep) else {
            print("⚠️ Шаг \(currentStep) вне диапазона или Steps не инициализирован")
            return
        }

        let stepDuration = TimeInterval(steps[currentStep].duration)

        // Очищаем предыдущий таймер
        stepTimer?.invalidate()
        stepTimer = nil

        guard isHintActive else {
            print("⏸ Подсказка неактивна — таймер шага не запущен")
            return
        }

        // Без retain cycle
        stepTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: false) { [weak self] _ in
            self?.nextStep()
        }

        print("✅ Таймер шага запущен на \(stepDuration) сек")
    }

        
    @objc private func nextStep() {
        guard let steps = ExerciseManager.shared.CurrentExercise.Steps,
              !steps.isEmpty else {
            print("⚠️ Нет шагов в упражнении — таймер остановлен")
            stopExercise()
            return
        }

        // Переход к следующему шагу
        ExerciseManager.shared.CurrentStep += 1

        // Проверка на выход за пределы
        if ExerciseManager.shared.CurrentStep >= steps.count {
            ExerciseManager.shared.CurrentStep = 0
            print("🔁 Упражнение завершено — начинаем заново")
        } else {
            print("➡️ Переход к шагу \(ExerciseManager.shared.CurrentStep)")
        }

        // Перезапуск таймера шага
        startStepTimer()

        // Обновление визуальной подсказки
        updateHintState()
    }

    
    @objc private func restartExercise() {
        guard let exercise = ExerciseManager.shared.CurrentExercise else {
            print("⚠️ Упражнение не инициализировано — перезапуск невозможен")
            return
        }

        // Сброс шага
        ExerciseManager.shared.CurrentStep = 0
        print("🔁 Перезапуск упражнения — шаг сброшен")

        // Перезапуск таймера шага
        startStepTimer()

        // Перезапуск таймера упражнения
        exerciseTimer?.invalidate()
        exerciseTimer = nil

        let duration = TimeInterval(exercise.ExerciseDuration ?? 0)
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.restartExercise()
        }

        print("✅ Таймер упражнения перезапущен на \(duration) сек")
    }

        
    func stopExercise() {
        stepTimer?.invalidate()
        stepTimer = nil

        exerciseTimer?.invalidate()
        exerciseTimer = nil

        print("🛑 Все таймеры остановлены и обнулены")
    }

        
        // Метод для обновления состояния визуальной подсказки
    @objc func updateHintState() {
        print("🎬 Упражнение запущено — обновление подсказки")

        let soundFileName = "metronome"
        let currentStep = ExerciseManager.shared.CurrentStep

        guard let steps = ExerciseManager.shared.CurrentExercise.Steps,
              steps.indices.contains(currentStep) else {
            print("⚠️ Шаг \(currentStep) вне диапазона или Steps не инициализирован")
            imageHint.image = pauseImage
            breathingHintWidgetButton.setTitle("Старт", for: .normal)
            return
        }

        let actionIndex = steps[currentStep].action
        let hintLabels = TranslationDownloader.shared.CurrentTranslation.commonButtons?.ExerciseSteps ?? []

        let (hintImage, buttonLabel): (UIImage, String) = {
            switch actionIndex {
            case 0:
                return (inhaleGif, hintLabels[0] ?? "inhale")
            case 1:
                return (exhalationGif, hintLabels[1] ?? "exhale")
            case 2:
                return (exhalationGif, hintLabels[2] ?? "pause")
            default:
                return (pauseImage, "start")
            }
        }()

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
