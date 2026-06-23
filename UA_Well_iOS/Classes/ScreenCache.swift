import Foundation
import UIKit

final class ScreenCache {
    static let shared = ScreenCache()
    
    var previousVC: UIViewController?
    private var cache: [AppScreen: UIViewController] = [:]
    private var cacheByName: [String: UIViewController] = [:]
    private var storyboardCache: [String: UIStoryboard] = [:]
    private let excludedFromCache: Set<String> = [
        "ExerciseView::ExerciseView",
        "LongTimeWork::LongTimeWork",
        "PreventionScreen::PreventionScreen",
        "SymptomTitle::SymptomTitle",
        "LTWDayDescription::LTWDayDescription"
    ]


    func storyboard(named name: String) -> UIStoryboard {
        if let cached = storyboardCache[name] {
            return cached
        }

        let storyboard = UIStoryboard(name: name, bundle: nil)
        storyboardCache[name] = storyboard
        return storyboard
    }

    func viewController(named identifier: String, storyboardName: String) -> UIViewController {
        let key = "\(storyboardName)::\(identifier)"
        let shouldCache = !excludedFromCache.contains(key)

        if shouldCache, let cachedVC = cacheByName[key] {
            print("♻️ Use VC from cache: \(key)")
            return cachedVC
        }

        let storyboard = storyboard(named: storyboardName)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)

        if shouldCache {
            cacheByName[key] = vc
            print("🆕 Created and cachaed VC: \(key)")
        } else {
            print("🆕 Created VC without cache: \(key)")
        }

        return vc
    }


    
    func viewController(for screen: AppScreen) -> UIViewController {
        if screen.isCacheable, let cachedVC = cache[screen] {
            print("♻️ Use VC from cache: \(screen.rawValue)")
            return cachedVC
        }

        let storyboard = UIStoryboard(name: screen.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: screen.rawValue)

        if screen.isCacheable {
            cache[screen] = vc
            print("🆕 Created and cachaed VC: \(screen.rawValue)")
        } else {
            print("🆕 Created VC without cache: \(screen.rawValue)")
        }

        return vc
    }

    func clear(screen: AppScreen) {
        cache.removeValue(forKey: screen)
        print("🧹 Cache cleared for VC: \(screen.rawValue)")
    }

        func clearAll() {
            cacheByName.removeAll()
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


