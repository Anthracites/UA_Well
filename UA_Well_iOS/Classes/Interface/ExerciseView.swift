import UIKit
import Foundation

class ExerciseView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    var buttonLabels: [String] = ["Next", "It helped", "Contact a specialist"]
    @IBOutlet weak var exerciseText: UITextView!
    var HelpExercisesCount: Int!
    var nextButton, itHelpedButton, contactSpecialistButton, startOverbutton: UIButton!
    var buttons = [UIButton?]()
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetExerices()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonLabels.count
    }
    func GetExerices()
    {
        let i: Int = QuickHelpManager.shared.CurrentExercise // индекс упражнения в текущем массиве
        let o: Int = QuickHelpManager.shared.CurrentExersicesArray[i] // индекс текущего упражения в массиве
        let _text = String(TranslationDownloader.shared.CurrentTranslation.Exercises[o].description)
        HelpExercisesCount = Int(QuickHelpManager.shared.CurrentExercise)
        exerciseText.text = String(o) + " " + _text
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
        print("Buttons count: " + String(buttons.count))
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
}
