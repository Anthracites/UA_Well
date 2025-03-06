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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetExerices()
        print("exerciseView - 1!!!!")
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
        if (isHintActive == true)
        {
            let _button = breathingHintWidgetButton
            print("Button name: ", _button?.titleLabel?.text as Any)
            _button!.addTarget(self, action: #selector(OnHintButtonClick), for: .touchUpInside)
        }
    }
    
    func GetExerices()
    {
        let i: Int = QuickHelpManager.shared.CurrentExercise // индекс упражнения в текущем массиве
        let o: Int = QuickHelpManager.shared.CurrentExersicesArray[i] // индекс текущего упражения в массиве
        let _text = String(TranslationDownloader.shared.CurrentTranslation.Exercises[o].description)
        HelpExercisesCount = Int(QuickHelpManager.shared.CurrentExercise)
        exerciseText.text = _text
        isHintActive = ExerciseManager.shared.Exercises[o].visualHint
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
    // Ебучий виджет, который придется копипастить, так как эта блядина, выведенная в отдельный класс, не завелась!!!!!
    
    //@objc func OnHintButtonClick(LabelString: String, HintButton: UIButton)
    
    
    @objc func OnHintButtonClick()
    {
        let _buttonLabel: String
        let i: Int = ExerciseManager.shared.CurrentStep
        let _actionIndex = ExerciseManager.shared.CurrentExercise.Steps![i].stepAction
        let _hintImage: UIImage
        
        switch  _actionIndex{
        case 1:
            _hintImage = inhaleGif
            _buttonLabel = "Вдох"
            
        case 2:
            _hintImage = exhalationGif
            _buttonLabel = "Выдох"
        case 3:
            _hintImage = pauseImage
            _buttonLabel = "Пауза"
        case 4:
            _buttonLabel = "Визуальная подсказка"//Добавить в переводы разные характеристики предметов
            _hintImage = pauseImage

        default:
            _buttonLabel = "Start"
            _hintImage = pauseImage

        }

        imageHint.image = _hintImage
        breathingHintWidgetButton.setTitle(_buttonLabel, for: .normal)
        //imageHint.image = reversedGifImage
    
        let j: Int = ExerciseManager.shared.CurrentExercise.Steps!.count
        
        if ((i+1) == j)
        {
            ExerciseManager.shared.CurrentStep = 0
        }
        else
        {
            ExerciseManager.shared.CurrentStep += 1
        }
        
        
            
            print("Start widget. Step count: ", ExerciseManager.shared.CurrentStep)
        print("Action index: ", i, "Button label: ", _buttonLabel)
            
        }
    }
