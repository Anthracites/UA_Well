import Foundation

class TranslationFileManager {

    static let shared = TranslationFileManager()
    private let fileManager = FileManager.default

    private let bundleFolderName = "Content/translations/TransJSON_BackUps"
    private let translationsRelativePath = "Content/translations"

    /// Version of the translation set bundled with the current app build.
    /// Bump this number EVERY TIME the contents of
    /// Content/translations/TransJSON_BackUps change (including bugfixes like
    /// the recent trailing-comma fix in 2.json/3.json).
    private let bundleTranslationsVersion = 2

    private let versionDefaultsKey = "TranslationsContentVersion"

    func prepareTranslations() {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            log("❌ Failed to resolve Documents directory")
            return
        }

        let translationsDirURL = documentsURL.appendingPathComponent(translationsRelativePath)

        let storedVersion = UserDefaults.standard.integer(forKey: versionDefaultsKey)
        // storedVersion == 0 means "nothing copied yet" — either the very first
        // launch, or an install that predates this versioning mechanism.
        let folderHasFiles = hasJSONFiles(at: translationsDirURL)

        // Only refresh the on-disk files from the bundle if the bundle's version
        // is newer than what's already on disk. If the disk already has a newer
        // version (e.g. something was fetched remotely later), the bundle won't
        // overwrite it.
        guard storedVersion < bundleTranslationsVersion || !folderHasFiles else {
            log("✅ Translations are already up to date (version \(storedVersion))")
            return
        }

        do {
            try fileManager.createDirectory(at: translationsDirURL, withIntermediateDirectories: true)
        } catch {
            log("❌ Failed to create directory \(translationsDirURL.path): \(error)")
            return
        }

        guard let bundleFolderURL = Bundle.main.resourceURL?.appendingPathComponent(bundleFolderName) else {
            log("❌ Could not find folder \(bundleFolderName) in Bundle")
            return
        }

        let copiedCount = copyJSONFiles(from: bundleFolderURL, to: translationsDirURL, overwrite: true)

        guard copiedCount > 0 else {
            log("❌ No translation files were copied — on-disk version is not updated")
            return
        }

        UserDefaults.standard.set(bundleTranslationsVersion, forKey: versionDefaultsKey)
        log("✅ Copied \(copiedCount) file(s). Translations version updated to \(bundleTranslationsVersion)")
    }

    /// Copies JSON files one by one, independently of each other — a failure on
    /// one file does not stop the rest from being copied (unlike the previous
    /// version, where the whole loop was inside a single do/catch).
    /// Returns the number of files actually copied.
    @discardableResult
    private func copyJSONFiles(from sourceDir: URL, to destinationDir: URL, overwrite: Bool) -> Int {
        let sourceFiles: [URL]
        do {
            sourceFiles = try fileManager
                .contentsOfDirectory(at: sourceDir, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "json" }
        } catch {
            log("❌ Failed to read Bundle folder \(sourceDir.path): \(error)")
            return 0
        }

        var copiedCount = 0
        for sourceURL in sourceFiles {
            let destinationURL = destinationDir.appendingPathComponent(sourceURL.lastPathComponent)
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    guard overwrite else {
                        copiedCount += 1
                        continue
                    }
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                copiedCount += 1
                log("📄 Copied file: \(sourceURL.lastPathComponent)")
            } catch {
                log("❌ Failed to copy \(sourceURL.lastPathComponent): \(error)")
                // Intentionally NOT breaking the loop — we still try to copy the remaining files.
            }
        }
        return copiedCount
    }

    private func hasJSONFiles(at directory: URL) -> Bool {
        guard let files = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return false
        }
        return files.contains { $0.pathExtension == "json" }
    }

    private func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
