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
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
     //   funkGetJSONs()
        _collectionView.reloadData()
        _collectionView.contentMode = .center

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        translations = TranslationDownloader.shared.Translations // Доступ к массиву translations
               // Используем массив translations
               print(translations)

        return translations.count
    }
    func didDismiss() {
        print("Main closed!!!")
    }
    
//    @objc func funkGetJSONs() {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let translationsURL = documentsURL.appendingPathComponent("Content/translations")
//        
//        print("Translations directory path: \(translationsURL.path)")
//        
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: translationsURL, includingPropertiesForKeys: nil)
//            jsonFiles = fileURLs.filter { $0.pathExtension == "json" }
//            print("Found \(jsonFiles.count) JSON files")
//            var i = Int()
//            for file in jsonFiles {
//                print(file.lastPathComponent)
//                i+=1;
//                print(String(i))
//            }
//        } catch {
//            print("Error getting files: \(error)")
//        }
//        
//        
//    }
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
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)

        newButoon.setBackgroundImage(commoButtonBG, for: .highlighted)
        newButoon.tag = indexPath.item

        //view.addSubview(cell.MenuButton)
        
        print("Cell added!")
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
            let storyboard = UIStoryboard(name: "HelpTypesMenu", bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: "HelpTypesMenu") as! HelpTypesMenu
            self.present(secondVC, animated: true, completion: nil)    }
    }

