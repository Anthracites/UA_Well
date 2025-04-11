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
        // cell.backgroundColor = .red
        //cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        let _label = TranslationDownloader.shared.CurrentTranslation.Symptoms[_number].symptom_name
        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        newButoon.titleLabel?.adjustsFontSizeToFitWidth = true
        newButoon.titleLabel?.minimumScaleFactor = 0.1
        newButoon.setTitle(_label, for: .normal)
        newButoon.tag = _number
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        newButoon.widthAnchor.constraint(equalToConstant: 360.0).isActive = true
        newButoon.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
      //  _burgerButton.addTarget(self, action: #selector(BurgerButoonOnClick), for: .touchUpInside)
        //print ("Sympton ID: ", newButoon.tag, ", symptom name: ", _label)
        
        
        //view.addSubview(cell.MenuButton)
        print("Button width: ", newButoon.frame.width)

        
        //print("Cell added!")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        //print("Index: ", indexPath.item)
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
