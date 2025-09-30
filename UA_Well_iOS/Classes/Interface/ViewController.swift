import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var мenuRightButton: UIButton!
    var jsonFiles: [URL] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    var translations: [Translation] = []
    var isFirstRun: Bool!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoToScreen()
        configureCollectionView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        translations = TranslationDownloader.shared.Translations
        return translations.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TranslationDownloader.shared.IsFirstRun = false
    }



    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        newButoon.setTitle(translations[indexPath.item].currentLanguage, for: .normal)
        cell.contentMode = .center
        cell.adjustFontSize(for: newButoon)

        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)

        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        newButoon.tag = indexPath.item

            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        }
        return cell
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton, _buttonIndex: Int)
    {
        let a = _currentButton.tag
        TranslationDownloader.shared.CurrentTranslation = translations[a]
        QuickHelpManager.shared.Symtoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        
        UserDefaults.standard.set(_currentButton.titleLabel?.text, forKey: "Language")
        
        let storyboard = UIStoryboard(name: "HelpTypesMenu", bundle: nil)
        // Инициализируем ViewController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "HelpTypesMenu") as! HelpTypesMenu
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func GoToScreen()
    {
        DispatchQueue.main.async {
            let savedLanguage = UserDefaults.standard.string(forKey: "Language")
            self.isFirstRun = TranslationDownloader.shared.IsFirstRun
            
            let _isAppOpenFromNotification = ExerciseManager.shared.IsAppOpenFromNotification
                    
            if (_isAppOpenFromNotification != true)
            {
                if (self.isFirstRun == true) && (savedLanguage != nil)
                {
                    
                    let storyboard = UIStoryboard(name: "HelpTypesMenu", bundle: nil)
                    // Инициализируем ViewController
                    let secondVC = storyboard.instantiateViewController(withIdentifier: "HelpTypesMenu") as! HelpTypesMenu
                    self.present(secondVC, animated: true, completion: nil)
                }
            }
            
            else {
                let type = ExerciseManager.shared.NotificationType

                let storyboardName: String

                   switch type {
                   case "PreventionAlarm":
                       storyboardName = "PreventionInstruction"
                       TherapyProgressTracker.shared.markTodayAsCompleted(for: .Prevention)
                       
                   case "LTWAlarm":
                       storyboardName = "LTWDayDescription"
                       TherapyProgressTracker.shared.markTodayAsCompleted(for: .LTW)

                   default:
                       storyboardName = "PreventionInstruction"
                   }
                ExerciseManager.shared.PreviousViewName = storyboardName
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                // Инициализируем ViewController
                let secondVC = storyboard.instantiateViewController(withIdentifier: storyboardName)
                self.present(secondVC, animated: true, completion: nil)
                
        
            }
        }
    }
    
    func configureCollectionView()
    {
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
         collectionView.dataSource = self
         collectionView.delegate = self
         collectionView.reloadData()
         collectionView.contentMode = .center
    }
    }





