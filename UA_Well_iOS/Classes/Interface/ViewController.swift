//
//  ViewController.swift
//  UA_Well_iOS
//
//  Created by Наталья Гусарова on 17.09.2024.
//
import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var MenuRightButton: UIButton!
    var jsonFiles: [URL] = []
    var commoButtonBG = UIImage(named: "CommonButtonBG")
    var translations: [Translation] = []
    var isFirstRun: Bool!
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            DispatchQueue.main.async {
                let savedLanguage = UserDefaults.standard.string(forKey: "Language")
                self.isFirstRun = TranslationDownloader.shared.IsFirstRun
                
                let _isAppOpenFromNotification = ExerciseManager.shared.IsAppOpenFromNotification
                        
                if (_isAppOpenFromNotification != true)
                {
                    if (self.isFirstRun == true) && (savedLanguage != nil)
                    {
                        
                        //print("Is first run: ", String(self.isFirstRun))
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
                    
                    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                    // Инициализируем ViewController
                    let secondVC = storyboard.instantiateViewController(withIdentifier: storyboardName)
                    self.present(secondVC, animated: true, completion: nil)
                    
            
                }
            }

       _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.reloadData()
        _collectionView.contentMode = .center
        //centerCollectionViewContent()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        translations = TranslationDownloader.shared.Translations // Доступ к массиву translations
        return translations.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TranslationDownloader.shared.IsFirstRun = false
        //print("Storyboard закрывается")
    }



    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let newButoon: UIButton = cell.MenuButton
        // Настройка ячейки
        //cell.backgroundColor = .red
        //let jsonFile = jsonFiles[indexPath.item]
        //cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: newButoon, isFilledButton: false)
        newButoon.setTitle(translations[indexPath.item].currentLanguage, for: .normal)
        cell.contentMode = .center
        cell.adjustFontSize(for: newButoon)

        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)

        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        newButoon.tag = indexPath.item

        //view.addSubview(cell.MenuButton)
        
        //print("Cell added!")
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
        print("Language selected and saved. Current language: ", _currentButton.titleLabel?.text)

            let storyboard = UIStoryboard(name: "HelpTypesMenu", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "HelpTypesMenu") as! HelpTypesMenu
            self.present(secondVC, animated: true, completion: nil)    }
    
    func centerCollectionViewContent() {
        guard let layout = _collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let itemHeight = layout.itemSize.height
        let spacing = layout.minimumLineSpacing
        let itemCount = translations.count

        let totalContentHeight = CGFloat(itemCount) * itemHeight + CGFloat(itemCount - 1) * spacing
        let topInset = max((_collectionView.frame.height - totalContentHeight) / 2, 0)

        _collectionView.contentInset.top = topInset

        print("Collection view height: \(_collectionView.frame.height)")
        print("Total content height: \(totalContentHeight)")
        print("Calculated top inset: \(topInset)")
    }


    
    }





