import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

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
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }
}
