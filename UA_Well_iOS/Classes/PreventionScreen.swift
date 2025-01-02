//PreventionScreen
import Foundation
import UIKit

class PreventionScreen:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    var dropDownLabels: [String] = ["Intensity", "Duration"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomDropDown", bundle: nil), forCellWithReuseIdentifier: "CustomDropDown")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dropDownLabels.count
    }

    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomDropDown", for: indexPath) as! CustomDropDown
        let newButoon: UIButton = cell.dropDown
        // Настройка ячейки
        // cell.backgroundColor = .red
        let _label = dropDownLabels[indexPath.item]
        cell.dropDown.backgroundColor = .gray
        cell.copyDDProperties(targetButton: newButoon)
        newButoon.setTitle(_label, for: .normal)
        cell.contentMode = .center
        //newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        //newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        
        view.addSubview(cell.dropDown)
        
        print("Cell added!")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
}

