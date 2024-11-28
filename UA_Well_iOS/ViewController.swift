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
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        _collectionView.dataSource = self
        _collectionView.delegate = self
        funkGetJSONs()
        _collectionView.reloadData()
        _collectionView.contentMode = .center
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonFiles.count
    }
    
    
    @objc func funkGetJSONs() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let translationsURL = documentsURL.appendingPathComponent("Content/translations")
        
        print("Translations directory path: \(translationsURL.path)")
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: translationsURL, includingPropertiesForKeys: nil)
            jsonFiles = fileURLs.filter { $0.pathExtension == "json" }
            print("Found \(jsonFiles.count) JSON files")
            var i = Int()
            for file in jsonFiles {
                print(file.lastPathComponent)
                i+=1;
                print(String(i))
            }
        } catch {
            print("Error getting files: \(error)")
        }


    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // _collectionView.backgroundColor = .cyan
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        // Настройка ячейки
        cell.backgroundColor = .red
        let jsonFile = jsonFiles[indexPath.item]
        cell.MenuButton.backgroundColor = .gray
        cell.copyButtonProperties(targetButton: cell.MenuButton)
        cell.MenuButton.setTitle(jsonFile.lastPathComponent, for: .normal)
        cell.contentMode = .center
        cell.MenuButton.contentMode = .center
                
        print("Cell added!")
        return cell
    }
}
