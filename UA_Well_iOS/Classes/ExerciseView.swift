import UIKit
import Foundation

class ExerciseView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    var helpTypes: [String] = ["Далее", "Связаться со специалистом", "Назад"]
    // @IBOutlet weak var _scrollView: UIScrollView!
    // @IBOutlet weak var _contentView: UIView!
    // @IBOutlet weak var _textView: UITextView!
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return helpTypes.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        let HelpType = helpTypes[indexPath.item]
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: true)
        newButoon.setBackgroundImage(commoButtonBG, for: .normal)
        newButoon.setTitle(HelpType, for: .normal)
        cell.contentMode = .center
        
        print("Cell added!")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
}
