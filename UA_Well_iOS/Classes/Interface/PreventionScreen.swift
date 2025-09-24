//PreventionScreen
import Foundation
import UIKit

class PreventionScreen:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var previousScreenName = "HelpTypesMenu"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton:UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var preventionTitle: UIView!
    @IBOutlet weak var dayCount: UILabel!
    @IBOutlet weak var descriptionText: AutoResizingTextView!
    var PPLabels: [String] = ["Sensity", "Duration"]
    var PPValues: [[String]] = [["Min", "Mid", "Max"],["Two", "Three", "Four"]]
    var intensityCurrentOptions, durationCurrentOptions: CustomDropDown!
    var currentIntensity,currentDuration: Int!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureText()
        configureLayout()
    }
    
    func configureText()
    {
        startButton.addTarget(self, action: #selector(GoToInstruction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        ExerciseManager.shared.CurrentHelpType = "Prevention"
        TranslateView()
        GetOptions()
        dayCount.text = DayCountLabel()
    }
    
    func configureLayout()
    {
        descriptionText.adjustHeight()

        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: contentView,
            title: preventionTitle,
            exerciseText: descriptionText,
            collectionView: collectionView,
            collectionViewItemsCount: 2,
            collectionViewItemsHeight: 100,
            okButton: startButton
        )
        
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    func configureCollectionView()
    {
        collectionView.register(UINib(nibName: "CustomDropDown", bundle: nil), forCellWithReuseIdentifier: "CustomDropDown")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.contentMode = .center
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func DayCountLabel()-> String
    {
        let _dayLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons?.DayOfTherapy
        let _dayCount = String(PreventionManager.shared.CurrentDay)
        let _label = (_dayLabel ?? "День терапии") + " " + _dayCount

        
        return _label
    }
    
    @objc func TranslateView()
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        backButton.setTitle(_translation?.commonButtons?.Return_to_help_type_page_title, for: .normal)
        startButton.setTitle(_translation?.commonButtons?.Start, for: .normal)
        titleText.text = _translation?.prevention?.Title
        descriptionText.text = _translation?.prevention?.Description
        
    }
    @objc func GetOptions()
    {
        currentIntensity = PreventionManager.shared.CurrentIntensity
        currentDuration =  PreventionManager.shared.CurrentDuration
    }
    
    @objc func TranslateDropDown(DDLabel: String, DropDown: CustomDropDown)
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        DropDown.ddLabel.text = _translation?.prevention?.IntesityLabel
        var _labels :[String] = []
        
        switch DDLabel
        {
        case "Sensity":
            DropDown.ddLabel.text = _translation?.prevention?.IntesityLabel
            if let _translationLabels = _translation?.prevention?.Intensivities
            {
                for _intesity in _translationLabels
                {
                    _labels.append(_intesity.Name)
                }
                DropDown.SetupPullDownMenu(DropDown: DropDown.dropDown, DropDownItems: _labels)
                DropDown.dropDown.setTitle(_translationLabels[currentIntensity].Name, for: .normal)
                intensityCurrentOptions = DropDown
                
            }
            
        case "Duration":
            DropDown.ddLabel.text = _translation?.prevention?.DurationLabel
            
            if let _translationLabels = _translation?.prevention?.Durations
            {
                for _duration in _translationLabels
                {
                    _labels.append(_duration.Name)
                }
                DropDown.SetupPullDownMenu(DropDown: DropDown.dropDown, DropDownItems: _labels)
                DropDown.dropDown.setTitle(_translationLabels[currentDuration].Name, for: .normal)
                durationCurrentOptions = DropDown
                
            }
            
        default:
            " "
        }
        
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomDropDown", for: indexPath) as! CustomDropDown
        let newButoon: UIButton = cell.dropDown
        let _label = PPLabels[indexPath.item]
        cell.contentMode = .center
        let _stringArray = PPValues[indexPath.item]
        cell.SetupPullDownMenu(DropDown: newButoon, DropDownItems: _stringArray)
        cell.ddLabel.text = _label
        cell.copyDDProperties(targetButton: newButoon)
        TranslateDropDown(DDLabel: cell.ddLabel.text!, DropDown: cell)


        return cell
    }
    
    @objc func SetOptions()
    {
        let _optionsCells = collectionView.visibleCells.compactMap { $0 as? CustomDropDown }
        PreventionManager.shared.CurrentIntensity = intensityCurrentOptions.CurrentOption
        PreventionManager.shared.CurrentDuration = durationCurrentOptions.CurrentOption
        print("индекс класса pScreen: \(String(describing: _optionsCells[0].CurrentOption))")
    }
    
    @objc func GoToInstruction()
    {
        SetOptions()
        
        let _name = "PreventionInstruction"
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }
    
    @objc func BackToPreviousScreen()
    {
        let _name = previousScreenName
        let storyboard = UIStoryboard(name: _name, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: _name)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()
        }
    }

}

