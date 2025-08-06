import Foundation

class TranslationFileManager {
    
    static let shared = TranslationFileManager()
    private let fileManager = FileManager.default
    
    private let bundleFolderName = "Content/translations/TransJSON_BackUps"
    
    func prepareTranslations() {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Не удалось получить путь к Documents")
            return
        }
        
        let translationsDirURL = documentsURL.appendingPathComponent("Content/translations")
        
        // Проверка: существует ли папка и есть ли в ней JSON-файлы
        var needsCopy = false
        if !fileManager.fileExists(atPath: translationsDirURL.path) {
            needsCopy = true
        } else {
            do {
                let existingFiles = try fileManager.contentsOfDirectory(at: translationsDirURL, includingPropertiesForKeys: nil)
                let jsonFiles = existingFiles.filter { $0.pathExtension == "json" }
                if jsonFiles.isEmpty {
                    needsCopy = true
                }
            } catch {
                print("⚠️ Ошибка при проверке содержимого папки: \(error)")
                needsCopy = true
            }
        }
        
        guard needsCopy else {
            print("✅ JSON-файлы уже существуют, копирование не требуется")
            return
        }
        
        // Создание папки, если нужно
        do {
            try fileManager.createDirectory(at: translationsDirURL, withIntermediateDirectories: true)
            print("📁 Папка создана: \(translationsDirURL.path)")
        } catch {
            print("❌ Не удалось создать папку: \(error)")
            return
        }
        
        // Получение пути к папке в Bundle
        guard let bundleFolderURL = Bundle.main.resourceURL?.appendingPathComponent(bundleFolderName) else {
            print("❌ Не удалось найти папку \(bundleFolderName) в Bundle")
            return
        }
        
        // Копирование файлов из Bundle
        do {
            let bundleFiles = try fileManager.contentsOfDirectory(at: bundleFolderURL, includingPropertiesForKeys: nil)
            let jsonFiles = bundleFiles.filter { $0.pathExtension == "json" }
            
            for sourceURL in jsonFiles {
                let destinationURL = translationsDirURL.appendingPathComponent(sourceURL.lastPathComponent)
                
                if !fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
                    print("📄 Скопирован файл: \(sourceURL.lastPathComponent)")
                } else {
                    print("🔁 Файл уже существует: \(sourceURL.lastPathComponent)")
                }
            }
            
            if let firstFile = jsonFiles.first {
                let firstFilePath = translationsDirURL.appendingPathComponent(firstFile.lastPathComponent).path
                print("✅ Переводы загружены. Первый файл: \(firstFilePath)")
            }
            
        } catch {
            print("JSONs folder: ", bundleFolderURL)
            print("❌ Ошибка при копировании файлов из Bundle: \(error)")
        }
    }
}

