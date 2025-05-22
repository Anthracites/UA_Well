import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    var notificationTitle: String!
    var notificationBody: String!
    var preventionAlarmIsOn, _longTermWorkIsOn: Bool!
    var notificationTime: DateComponents!

    private init() {}

    // Запрос разрешения на уведомления
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение получено")
            } else {
                print("Уведомления отключены")
            }
        }
    }

    // Создание уведомления
    func scheduleNotification() {
        GetNotificationParameters()
        print("Get notification time: \(notificationTime)")
        
        let preventionAlarmIsOn = UserDefaults.standard.bool(forKey: "PreventionAlarm")
        if (preventionAlarmIsOn == true) && (notificationTime != nil)
        {
            let content = UNMutableNotificationContent()
            content.title = notificationTitle
            content.body = notificationBody
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = notificationTime.hour
            dateComponents.minute = notificationTime.minute

            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func GetNotificationParameters()
    {
            if let n = UserDefaults.standard.object(forKey: "PreventionAlarmTime") as? DateComponents
        {
                notificationTime = n
                notificationTitle = TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.Title
                notificationBody = TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.Body_prevention
        }
        
    }
}
