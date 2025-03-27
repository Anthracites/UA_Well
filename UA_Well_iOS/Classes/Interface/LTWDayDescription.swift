import Foundation
import UIKit

class LTWDayDescription:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate 
{
    var _previousScreenName = "LongTimeWork"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var _collectionView: UICollectionView!
    var TherapyDay: Int?
    var buttonLabels: [String] = ["ExerciseView", "AboutUsAndContactUs"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        SetUpButton()
        ExerciseManager.shared.CurrentHelpType = "LongTimeWork"
    }
    
    @objc func SetUpButton()
    {
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: _previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonLabels.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        newButoon.tag = indexPath.item
        newButoon.setTitle(buttonLabels[indexPath.item], for: .normal)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        cell.contentMode = .center
        
        if ((TherapyDay != 0)&&(indexPath.item == 0))
        {
            newButoon.isHidden = true
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        print ("Cell added. Cell index: ", indexPath.item)
        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        //QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.Exercises.
        QuickHelpManager.shared.Symtoms.sort(by: { $0.symptom_ID < $1.symptom_ID})
        ExerciseManager.shared.QuickHelpExercises.sort(by: { $0.symptom_ID < $1.symptom_ID})
        QuickHelpManager.shared.CurrentExersicesArray = ExerciseManager.shared.QuickHelpExercises[0].help_exercise_array
        QuickHelpManager.shared.CurrentExercise = 1
        QuickHelpManager.shared.CurrentSyptom  = QuickHelpManager.shared.Symtoms[5]
        
        
        
        let _storyBoardName = buttonLabels[_currentButton.tag]
        
        let storyboard = UIStoryboard(name: _storyBoardName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: _storyBoardName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
        
    }
}
