//PreventionScreen
import Foundation
import UIKit

class PreventionScreen:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var previousScreenName = "HelpTypesMenu"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var startButton:UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    var PPLabels: [String] = ["Sensity", "Duration"]
    var PPValues: [[String]] = [["Min", "Mid", "Max"],["Two", "Three", "Four"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomDropDown", bundle: nil), forCellWithReuseIdentifier: "CustomDropDown")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        
        startButton.addTarget(self, action: #selector(GoToInstruction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        TranslateView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    @objc func TranslateView()
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        backButton.setTitle(_translation?.commonButtons?.Return_to_help_type_page_title, for: .normal)
        startButton.setTitle(_translation?.commonButtons?.Start, for: .normal)
        titleText.text = _translation?.prevention?.Title
        descriptionText.text = _translation?.prevention?.Description

    }
    @objc func GetConfig()
    {
        
    }
    
    @objc func TranslateDropDown(DDLabel: String, DropDown: CustomDropDown)
    {
        let DDValues = [String]()
        let _translation = TranslationDownloader.shared.CurrentTranslation
        DropDown.ddLabel.text = _translation?.prevention?.IntesityLabel
        
        switch DDLabel
        {
        case "Sensity":
            DropDown.ddLabel.text = _translation?.prevention?.IntesityLabel

        case "Duration":
            DropDown.ddLabel.text = _translation?.prevention?.DurationLabel
        default:
            " "
        }

    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomDropDown", for: indexPath) as! CustomDropDown
        let newButoon: UIButton = cell.dropDown
        // Настройка ячейки
        //cell.backgroundColor = .red
        let _label = PPLabels[indexPath.item]
        //cell.dropDown.backgroundColor = .gray
        cell.copyDDProperties(targetButton: newButoon)
        cell.contentMode = .center
        let _stringArray = PPValues[indexPath.item]
        cell.SetupPullDownMenu(DropDown: newButoon, DropDownItems: _stringArray)
        newButoon.setTitle(cell.dropDown.menu?.children[0].title, for: .normal)
        cell.ddLabel.text = _label
        TranslateDropDown(DDLabel: cell.ddLabel.text!, DropDown: cell)
        //newButoon.center = CGPoint(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.midY) // Центрируем кнопку внутри ячейки
        //newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        //newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        
        
        //view.addSubview(cell.dropDown)
        
        print("Prevention scereen: Cell added!")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    @objc func GoToInstruction()
    {
        let _sbName = "PreventionInstruction"
            let storyboard = UIStoryboard(name: _sbName, bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: _sbName)
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func BackToPreviousScreen()
    {
        let storyboard = UIStoryboard(name: previousScreenName, bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: previousScreenName)
        // Переход к новому ViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    

}

