import Foundation
import UIKit

public class TranslationDownloader {
    
    var translationJsons: [URL] = []
    var Translations: [Translation] = []
    var currentLanguage:String = "";
    
    @objc func GetStrings()
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let translationsURL = documentsURL.appendingPathComponent("Content/translations")
        //let url = Bundle.main.url(forResource: "HelpTypes", withExtension: "json")
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: translationsURL, includingPropertiesForKeys: nil)
            translationJsons = fileURLs.filter { $0.pathExtension == "json" }
            print("Found \(translationJsons.count) JSON files")
            print("Translations directory path: \(translationsURL.path)")

                        
                do {
                    for _json in translationJsons
                    {
                        let data = try Data(contentsOf: _json)
                        let decoder = JSONDecoder()
                        let _translations = try decoder.decode([Translation].self, from: data)
                        Translations = _translations
                        print(Translations[0].currentLanguage)
                    }
                } catch {
                    print("Ошибка при загрузке данных: \(error)")
                }
        }
            catch {
                print("Error getting files: \(error)")
            }
        
        
    }
}
    
