import Foundation
import UIKit


class HelpTypesMenu:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    var previousScreenName = "Main"
    var helpTypes: [HelpType] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpTypes = ExerciseManager.shared.HelpTypes
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.contentMode = .center
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_language_selecttion_title, for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return helpTypes.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        // Настройка ячейки
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        let _label: String = TranslationDownloader.shared.CurrentTranslation.HelpTypes[indexPath.item].help_type_name
        newButoon.setTitle(_label, for: .normal)
        cell.adjustFontSize(for: newButoon)
        newButoon.tag = indexPath.item

        newButoon.titleLabel?.minimumScaleFactor = 0.1
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        ExerciseManager.shared.CurrentHelpType = helpTypes[_currentButton.tag].help_type_name

        if let _label = helpTypes[_currentButton.tag].help_type_name as Optional
        {
            //print(String(_label))
            let storyboard = UIStoryboard(name: _label, bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: _label)
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: previousScreenName) as! ViewController
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
}
