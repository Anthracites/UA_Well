import Foundation
import UIKit


class HelpTypesMenu:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _backButton: UIButton!
    var _previousScreenName = "Main"
    var helpTypes: [HelpType] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        GetTypesJsons()
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        _backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return helpTypes.count
    }
    
    @objc func GetTypesJsons()
    {
        if
            let url = Bundle.main.url(forResource: "HelpTypes", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let helpType = try decoder.decode([HelpType].self, from: data)
                print(helpType)
                helpTypes = helpType
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
        //cell.backgroundColor = .red
        let HelpType = helpTypes[indexPath.item]
        //cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: newButoon)
        newButoon.setTitle(HelpType.help_type_name, for: .normal)
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
            let storyboard = UIStoryboard(name: _label, bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: _label)
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
