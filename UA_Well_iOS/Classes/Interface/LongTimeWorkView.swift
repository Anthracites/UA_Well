import Foundation
import UIKit

class LongTimeWorkView:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    var _previousScreenName = "HelpTypesMenu"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: AutoResizingTextView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var header:UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var LTWTitle: UIView!

    var popUpButtonLabels: [String] = ["One", "Five", "Ten", "Fifvteen"]
    @IBOutlet weak var dayCount: UILabel!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?



    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.contentMode = .center
        SetUpButton()
        TranslateView()
        descriptionText.adjustHeight()


        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView as! UIScrollView,
            contentView: contentView,
            title: LTWTitle,
            exerciseText: descriptionText,
            collectionView: _collectionView,
            collectionViewItemsCount: 4,
            collectionViewVerticalSpacing: 30
        )
        
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    func DayCountLabel()-> String
    {
        let _dayLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons?.DayOfTherapy
        let _dayCount = String(LTWManager.shared.DayCount)
        let _label = (_dayLabel ?? "День терапии") + " " + _dayCount

        
        return _label
    }


    
    @objc func TranslateView()
    {
        titleText.text = TranslationDownloader.shared.CurrentTranslation.HelpTypes[1].help_type_name
        dayCount.text = DayCountLabel()
        descriptionText.text = TranslationDownloader.shared.CurrentTranslation.longTermWork?.Description
        backButton.setTitle(TranslationDownloader.shared.CurrentTranslation.commonButtons?.Return_to_help_type_page_title, for: .normal)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         //_collectionView.backgroundColor = .cyan
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
            print("Button size setuped in LTW View")
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
