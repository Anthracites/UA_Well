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
    }
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        newButoon.setTitle(popUpButtonLabels[indexPath.item], for: .normal)
        cell.contentMode = .center
        
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
}
