import Foundation
import UIKit


class QuickHelpSymptomsMenu:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    var _previousScreenName = "HelpTypesMenu"
    var quickHelpExercises: [HelpExercises] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    var sortedIndices: [Int] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quickHelpExercises = ExerciseManager.shared.QuickHelpExercises
        sortedIndices = sortButtonsAlphabetically()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.contentMode = .center
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_help_type_page_title, for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickHelpExercises.count
    }

    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = sortedIndices[indexPath.item]
        let symptoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        let symptom = symptoms[index]
          

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton

        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        let _label = TranslationDownloader.shared.CurrentTranslation.Symptoms[index].symptom_name
        newButoon.setTitle(_label, for: .normal)
        cell.adjustFontSize(for: newButoon)
        newButoon.tag = index
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
           let backgroundImage = newButoon.backgroundImage(for: .normal) {

            flowLayout.scrollDirection = .vertical

            // Получаем реальные горизонтальные отступы
            let leftInset = collectionView.contentInset.left + flowLayout.sectionInset.left
            let rightInset = collectionView.contentInset.right + flowLayout.sectionInset.right
            let totalHorizontalInset = leftInset + rightInset

            let buttonWidth = collectionView.frame.width - totalHorizontalInset
            
            // Вычисляем высоту кнопки с ограничением максимальной высоты
            let rawHeight = cell.calculateButtonSize(basedOn: .width(buttonWidth), backgroundImage: backgroundImage, cellSpacing: flowLayout.minimumLineSpacing)
            let maxHeight: CGFloat = UIScreen.main.bounds.width < 400 ? 80 : 120
            let buttonHeight = min(rawHeight, maxHeight)

            // Настраиваем размер ячейки
            flowLayout.itemSize = CGSize(width: buttonWidth, height: buttonHeight + flowLayout.minimumLineSpacing)

            // Применяем размеры к кнопке
            newButoon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newButoon.widthAnchor.constraint(equalToConstant: buttonWidth),
                newButoon.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        }

        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        if (QuickHelpManager.shared.Symtoms[_currentButton.tag].symptom_name as Optional) != nil
        {
            let storyboard = UIStoryboard(name: "SymptomTitle", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SymptomTitle")
            QuickHelpManager.shared.CurrentSyptom = QuickHelpManager.shared.Symtoms[_currentButton.tag]
            quickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
            QuickHelpManager.shared.CurrentExersicesArray = quickHelpExercises[_currentButton.tag].help_exercise_array
            QuickHelpManager.shared.CurrentExercise = 0;
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: _previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func sortButtonsAlphabetically() -> [Int] {
        var sortedIndices: [Int] = []
        let symptoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        sortedIndices = symptoms.indices.sorted {
            symptoms[$0].symptom_name.localizedCompare(symptoms[$1].symptom_name) == .orderedAscending
        }
        return sortedIndices
    }

}
