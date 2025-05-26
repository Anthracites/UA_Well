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
        
        let preventionAlarmIsOn = UserDefaults.standard.bool(forKey: "PreventionAlarm")
        if (preventionAlarmIsOn == true) && (notificationTime != nil)
        {
            let content = UNMutableNotificationContent()
            content.title = notificationTitle
            content.body = notificationBody
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 23
            dateComponents.minute = 12

            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
                } else {
                    print("Уведомление запланировано на ",dateComponents)
                    print("Current time: ", Date())
                }
            }
        }
        else{
            print("Ошибка:")
        }
    }
    
    @objc func GetNotificationParameters()
    {
        if let n = UserDefaults.standard.object(forKey: "PreventionAlarmTime") as? String
        {
                    let components = n.split(separator: ":")
                    if let hours = Int(components[0]), let minutes = Int(components[1]) {
                        notificationTime = DateComponents()
                        notificationTime.hour = hours
                        notificationTime.minute = minutes
                        //print("Часы: \(hours), Минуты: \(minutes)")
                    }
        }
        notificationTitle = TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.Title
        notificationBody = TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.Body_prevention
    }
}
