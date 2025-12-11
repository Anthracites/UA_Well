import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = LaunchScreen()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        //CacheManager.shared.initializeCacheManager()
        TranslationFileManager.shared.prepareTranslations()
        TranslationDownloader.shared.initializeTranslations()
        ExerciseManager.shared.initializeExercises()
        PreventionManager.shared.initializePreventionManager()
        LTWManager.shared.initializeLTWManager()
        TranslationDownloader.shared.IsFirstRun = true
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        //UNUserNotificationCenter.current().delegate = self
        NotificationManager.shared.requestAuthorization()
        QuickHelpManager.shared.Symtoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        
       // print("Is from notifications: ", ExerciseManager.shared.IsAppOpenFromNotification)
        
        return true
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        ExerciseManager.shared.IsAppOpenFromNotification = true
//        
//        if let type = response.notification.request.content.userInfo["screenID"] as? String {
//            // Сохраняем, чтобы использовать позже
//            UserDefaults.standard.set(type, forKey: "IncomingNotificationType")
//            ExerciseManager.shared.IsAppOpenFromNotification = true
//            ExerciseManager.shared.NotificationType = type
//            print("Notification type: ", type)
//        }
//        
//        switch response.actionIdentifier {
//        case "MUTE_10_MIN":
//            DelayNotification(NotificationContent: response.notification.request.content as! UNMutableNotificationContent, DelayTime: 600)
//            
//        case "CANCEL_ACTION":
//            DelayNotification(NotificationContent: response.notification.request.content as! UNMutableNotificationContent, DelayTime: 86400)
//            
//        default:
//            break
//        }
//        
//        
//    }
//    
//    @objc func DelayNotification(NotificationContent: UNMutableNotificationContent, DelayTime: TimeInterval)
//    {
//        let originalContent = NotificationContent
//        
//        let newContent = UNMutableNotificationContent()
//        newContent.title = originalContent.title
//        newContent.body = originalContent.body
//        newContent.sound = originalContent.sound
//        newContent.categoryIdentifier = originalContent.categoryIdentifier
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: DelayTime, repeats: false)
//        
//        let newRequest = UNNotificationRequest(identifier: UUID().uuidString, content: newContent, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(newRequest) { error in
//            if let error = error {
//                print("Ошибка при переносе уведомления: \(error)")
//            } else {
//                print("Уведомление перенесено на 10 минут")
//            }
//        }
//    }
}

