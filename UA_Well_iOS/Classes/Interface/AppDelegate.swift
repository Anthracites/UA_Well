//
//  AppDelegate.swift
//  UA_Well_iOS
//
//  Created by Наталья Гусарова on 17.09.2024.
//

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
        TranslationDownloader.shared.initializeTranslations()
        ExerciseManager.shared.initializeExercises()
        PreventionManager.shared.initializePreventionManager()
        TranslationDownloader.shared.IsFirstRun = true
        UNUserNotificationCenter.current().delegate = self
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleNotifications()
        QuickHelpManager.shared.Symtoms = TranslationDownloader.shared.CurrentTranslation.Symptoms
        
        print("Is from notifications: ", ExerciseManager.shared.IsAppOpenFromNotification)
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ExerciseManager.shared.IsAppOpenFromNotification = true
        
        switch response.actionIdentifier {
        case "MUTE_10_MIN":
            print("🔕 Мутим на 10 минут")
            
            // Получаем оригинальное содержимое
            let originalContent = response.notification.request.content
            
            // Создаём новое уведомление с задержкой 10 мин
            let newContent = UNMutableNotificationContent()
            newContent.title = originalContent.title
            newContent.body = originalContent.body
            newContent.sound = originalContent.sound
            newContent.categoryIdentifier = originalContent.categoryIdentifier
            newContent.userInfo = originalContent.userInfo
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: false) // 600 сек = 10 мин
            
            let newRequest = UNNotificationRequest(identifier: UUID().uuidString, content: newContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(newRequest) { error in
                if let error = error {
                    print("Ошибка при переносе уведомления: \(error)")
                } else {
                    print("Уведомление перенесено на 10 минут")
                }
            }
            
            
        default:
            break
        }
        
        
    }
}

