import Foundation
import UIKit


class QuickHelpSymptomsMenu:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _backButton: UIButton!
    var _previousScreenName = "HelpTypesMenu"
    var quickHelpExercises: [Exercise] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")


    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetExersiceJsons()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        GetExersiceJsons()
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        _backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickHelpExercises.count
    }
    
    @objc func GetExersiceJsons()
    {
        if
            let url = Bundle.main.url(forResource: "Quick_help_exercise", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exerciseData = try decoder.decode([Exercise].self, from: data)
                print(exerciseData)
                quickHelpExercises = exerciseData
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        // Настройка ячейки
       // cell.backgroundColor = .red
        let Quick_help_exercise = quickHelpExercises[indexPath.item]
        //cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: newButoon)
        newButoon.setTitle(Quick_help_exercise.symptom_name, for: .normal)
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        
        
        //view.addSubview(cell.MenuButton)
        
        print("Cell added!")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        if let _label = _currentButton.titleLabel?.text
        {
            print(String(_label))
            let storyboard = UIStoryboard(name: "SymptomTitle", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SymptomTitle")
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
}
