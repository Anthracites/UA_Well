//
//  ViewController.swift
//  UA_Well_iOS
//
//  Created by Наталья Гусарова on 17.09.2024.
//

import UIKit
import Foundation


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {}
    
    @IBOutlet var MenuRightButton: UIButton!
    var jsonFiles: [URL] = []
        
        
    @IBOutlet weak var _collectionView: UICollectionView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            _collectionView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomTableViewCell")
            _collectionView.dataSource = self
            _collectionView.delegate = self
            super.viewDidLoad()
            funkGetJSONs();
        }
        
        
        @objc func InstMenuButtons()
        {
            
        }
        
        @objc func funkGetJSONs()
        {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let translationsURL = documentsURL.appendingPathComponent("Content/translations")
            
            print("Translations directory path: \(translationsURL.path)")
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: translationsURL, includingPropertiesForKeys: nil)
                jsonFiles = fileURLs.filter { $0.pathExtension == "json" }
                print("Found \(jsonFiles.count) JSON files")
                for file in jsonFiles {
                    print(file.lastPathComponent)
                }
            } catch {
                print("Error getting files: \(error)")
            }
        }
        
        
        @objc func uploadTranslations()
        {
            var i = Int();
            jsonFiles.forEach { Language in
                i+=1;
                print(String(i));
            }
        }
    }


