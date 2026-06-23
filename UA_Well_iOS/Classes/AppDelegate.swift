import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
        
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = LaunchScreen()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        TranslationFileManager.shared.prepareTranslations()
        TranslationDownloader.shared.initializeTranslations()
        ExerciseManager.shared.initializeExercises()
        PreventionManager.shared.initializePreventionManager()
        LTWManager.shared.initializeLTWManager()
        TranslationDownloader.shared.IsFirstRun = true
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        NotificationManager.shared.requestAuthorization()
        QuickHelpManager.shared.Symtoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        return true
    }
}

