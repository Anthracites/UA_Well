import Foundation
import UIKit

class LongTimeWorkView:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    var _previousScreenName = "HelpTypesMenu"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var _collectionView: UICollectionView!
    var popUpButtonLabels: [String] = ["One", "Five", "Ten", "Fifvteen"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        SetUpButton()
        TranslateView()
    }
    
    @objc func TranslateView()
    {
        titleText.text = TranslationDownloader.shared.CurrentTranslation.HelpTypes[1].help_type_name
        descriptionText.text = TranslationDownloader.shared.CurrentTranslation.longTermWork?.Description
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_help_type_page_title, for: .normal)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        newButoon.setTitle(TranslationDownloader.shared.CurrentTranslation.longTermWork?.TherapyDays[indexPath.item].TherapyPartName, for: .normal)
        newButoon.tag = indexPath.item
        cell.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)

        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popUpButtonLabels.count
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
    
    @objc func OnClickMenuButton(_currentButton: UIButton, _buttonIndex: Int)
    {

            let storyboard = UIStoryboard(name: "LTWDayDescription", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LTWDayDescription") as! LTWDayDescription
            LTWManager.shared.CurrentDay = _currentButton.tag
            self.present(secondVC, animated: true, completion: nil)
        print("Day index: ", _currentButton.tag)
    }
}
