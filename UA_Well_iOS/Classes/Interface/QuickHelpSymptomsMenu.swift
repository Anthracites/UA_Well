import Foundation
import UIKit


class QuickHelpSymptomsMenu:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _backButton: UIButton!
    var _previousScreenName = "HelpTypesMenu"
    var quickHelpExercises: [HelpExercises] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quickHelpExercises = ExerciseManager.shared.QuickHelpExercises
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        _backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        _backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_help_type_page_title, for: .normal)
        _backButton.titleLabel?.adjustsFontSizeToFitWidth = true

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickHelpExercises.count
    }

    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        let _number = TranslationDownloader.shared.CurrentTranslation.Symptoms[indexPath.item].symptom_ID
        // Настройка ячейки
         //cell.backgroundColor = .red
        //cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        let _label = TranslationDownloader.shared.CurrentTranslation.Symptoms[_number].symptom_name
        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        newButoon.setTitle(_label, for: .normal)
        newButoon.titleLabel?.adjustsFontSizeToFitWidth = true
        newButoon.titleLabel?.minimumScaleFactor = 0.1
        newButoon.tag = _number
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
//        newButoon.widthAnchor.constraint(equalToConstant: 360.0).isActive = true
//        newButoon.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        
        //view.addSubview(cell.MenuButton)
        //print("Button width: ", newButoon.frame.width)

        
        //print("Cell added!")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
           let backgroundImage = newButoon.backgroundImage(for: .normal) {

            flowLayout.scrollDirection = .vertical

            // Получаем реальные горизонтальные отступы
            let leftInset = collectionView.contentInset.left + flowLayout.sectionInset.left
            let rightInset = collectionView.contentInset.right + flowLayout.sectionInset.right
            let totalHorizontalInset = leftInset + rightInset

            let buttonWidth = collectionView.frame.width - totalHorizontalInset

            // Вычисляем высоту кнопки с ограничением максимальной высоты
            let rawHeight = cell.calculateButtonHeight(for: buttonWidth, backgroundImage: backgroundImage, cellSpacing: flowLayout.minimumLineSpacing)
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
            //print("Buttom size: ", buttonWidth, "x", buttonHeight)

        }



        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        if let _label = QuickHelpManager.shared.Symtoms[_currentButton.tag].symptom_name as Optional
        {
            //print(String(_label))
            let storyboard = UIStoryboard(name: "SymptomTitle", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SymptomTitle")
            QuickHelpManager.shared.CurrentSyptom = QuickHelpManager.shared.Symtoms[_currentButton.tag]
            quickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
            QuickHelpManager.shared.CurrentExersicesArray = quickHelpExercises[_currentButton.tag].help_exercise_array
            QuickHelpManager.shared.CurrentExercise = 0;
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
            //print ("Current symptomID: ", _currentButton.tag, ", current exercise array: ", QuickHelpManager.shared.CurrentExersicesArray as Any)
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
}
