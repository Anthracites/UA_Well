import Foundation
import UIKit

final class ScreenCache {
    static let shared = ScreenCache()

    private var cache: [AppScreen: UIViewController] = [:]

    func viewController(for screen: AppScreen) -> UIViewController {
        if screen.isCacheable, let cachedVC = cache[screen] {
            print("♻️ Используем кэшированный VC: \(screen.rawValue)")
            return cachedVC
        }

        let storyboard = UIStoryboard(name: screen.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: screen.rawValue)

        if screen.isCacheable {
            cache[screen] = vc
            print("🆕 Создан и закэширован VC: \(screen.rawValue)")
        } else {
            print("🆕 Создан VC без кэширования: \(screen.rawValue)")
        }

        return vc
    }

    func clear(screen: AppScreen) {
        cache.removeValue(forKey: screen)
        print("🧹 Кэш очищен для VC: \(screen.rawValue)")
    }

    func clearAll() {
        cache.removeAll()
        print("🧼 Кэш всех VC очищен")
    }
}

enum AppScreen: String, CaseIterable {
    case aboutTheApplication = "AboutTheApplication"
    case aboutUsAndContactUs = "AboutUsAndContactUs"
    case exerciseView = "ExerciseView"
    case helpTypesMenu = "HelpTypesMenu"
    case languageSelectionMenu = "LanguageSelectionMenu"
    case launchScreen = "LaunchScreen"
    case longTimeWork = "LongTimeWork"
    case ltwDayDescription = "LTWDayDescription"
    case main = "Main"
    case popUpView = "PopUpView"
    case preventionInstruction = "PreventionInstruction"
    case preventionScreen = "PreventionScreen"
    case quickHelp = "QuickHelp"
    case symptomTitle = "SymptomTitle"

    var storyboardName: String {
        return self.rawValue
    }

    var isCacheable: Bool {
        switch self {
        case .exerciseView, .longTimeWork, .preventionScreen, .symptomTitle, .ltwDayDescription:
            return false
        default:
            return true
        }
    }
}


