import Foundation
import UIKit

class TranslationDownloader {
    
    static let shared = TranslationDownloader() // Singleton
    
    var Translations: [Translation] = []
    var CurrentTranslation: Translation!
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations() {
        // Если массив translations уже не пустой, пропускаем загрузку
        guard Translations.isEmpty else { return }
        
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let translationsDirURL = documentsURL.appendingPathComponent("Content/translations")
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: translationsDirURL, includingPropertiesForKeys: nil).filter { $0.pathExtension == "json" }
            for fileURL in fileURLs {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    
                    let tempTranslations = try decoder.decode([TemporaryTranslation].self, from: data)
                    
                    var currentLanguage: String?
                    var commonButtons: Translation.CommonButtons?
                    
                    for tempTranslation in tempTranslations {
                        if let language = tempTranslation.currentLanguage {
                            currentLanguage = language
                        }
                        if let buttons = tempTranslation.commonButtons {
                            commonButtons = buttons
                        }
                    }
                    
                    if let currentLanguage = currentLanguage, let commonButtons = commonButtons {
                        let translation = Translation(currentLanguage: currentLanguage, commonButtons: commonButtons)
                        Translations.append(translation)
                    }
                } catch {
                    print("Ошибка при загрузке данных из файла \(fileURL.lastPathComponent): \(error)")
                }
            }
            
            print("Translations loaded successfully! Loaded from: " + fileURLs[0].absoluteString)
        } catch {
            print("Ошибка при получении списка файлов: \(error)")
        }
    }
    
    private struct TemporaryTranslation: Codable {
        let currentLanguage: String?
        let commonButtons: Translation.CommonButtons?
        
        enum CodingKeys: String, CodingKey {
            case currentLanguage
            case commonButtons = "Common_buttons"
        }
    }
}
