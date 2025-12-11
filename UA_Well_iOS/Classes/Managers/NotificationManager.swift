import UserNotifications

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    private var PreventionAlarmNotification, LTWAlarmNotification: AlarmNotification?
    
    private override init() {}

    // Запрос разрешения на уведомления
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Ошибка авторизации уведомлений: \(error.localizedDescription)")
                return
            }
        }
    }

    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        registerNotificationCategories()

        // LTW
        let isLTWOn = UserDefaults.standard.bool(forKey: "LTWAlarm")
        if isLTWOn && IsTherapyActive(CurrentTherapyDay: "LTWCurrentDay", TherapyDuration: "LTWDuration", TherapyDurations: LTWManager.shared.LTWDurations) {
            let times = ["12:00", "15:00", "18:00"]
            for time in times {
                let notification = createNotification(
                    time: time,
                    type: "LTWAlarm",
                    screen: "LTWDayDescription",
                    bodyKey: "Body_long_time_work",
                )
                scheduleNotification(_alarmNotification: notification)
            }
        } else {
            LTWManager.shared.ResetToDefault()
        }

        // Prevention
        let isPreventionOn = UserDefaults.standard.bool(forKey: "PreventionAlarm")
        if isPreventionOn && IsTherapyActive(CurrentTherapyDay: "PreventionCurrentDay", TherapyDuration: "PreventionDuration", TherapyDurations: PreventionManager.shared.PreventionDurations) {
            var times = ["12:00", "15:00", "18:00"]

            let intensity = UserDefaults.standard.integer(forKey: "PreventionIntensity")
            if intensity == 1 || intensity == 2 {
                times.append("21:00")
            }

            for time in times {
                let notification = createNotification(time: time, type: "PreventionAlarm", screen: "PreventionInstruction", bodyKey: "Body_prevention")
                scheduleNotification(_alarmNotification: notification)
            }
        } else {
            PreventionManager.shared.ResetToDefault()
        }
    }


    
    func registerNotificationCategories() {
        let _muteTitle = (TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.MuteButtonTitle)!
        let _cancelTitle = (TranslationDownloader.shared.CurrentTranslation.alarmNotifications?.CancelButtonTitle)!
        
        let mute = UNNotificationAction(identifier: "MUTE_10_MIN", title: _muteTitle, options: [])
        let cancel = UNNotificationAction(identifier: "CANCEL_ACTION", title:_cancelTitle, options: [.destructive])

        let category = UNNotificationCategory(identifier: "ALARM_CATEGORY", actions: [mute, cancel], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    
    // Создание уведомления
    func scheduleNotification(_alarmNotification: AlarmNotification)
    {
        let _isAlarmOn = _alarmNotification.IsAlarmOn
        if (_isAlarmOn == true) && (_alarmNotification.NotificationTime != nil)
        {
            let trigger = UNCalendarNotificationTrigger(dateMatching: _alarmNotification.NotificationTime, repeats: true)
            let request = UNNotificationRequest(identifier: _alarmNotification.AlarmType, content: _alarmNotification.NotificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
                } else {
                    print("Уведомление запланировано на ",_alarmNotification.NotificationTime, _alarmNotification.AlarmType)
                }
            }
        }
        else{
//            print("Error shedule notification:")
        }
    }
    
    func createNotification(time: String, type: String, screen: String, bodyKey: String) -> AlarmNotification {
        let translation = TranslationDownloader.shared.CurrentTranslation
        let title = translation?.alarmNotifications?.Title ?? "Уведомление"

        var body = ""
        switch bodyKey {
        case "Body_prevention":
            body = translation?.alarmNotifications?.Body_prevention ?? ""
        case "Body_long_time_work":
            body = translation?.alarmNotifications?.Body_long_time_work ?? ""
        default:
            body = ""
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["screenID": type]
        content.categoryIdentifier = "ALARM_CATEGORY"

        let components = time.split(separator: ":")
        var dateComponents = DateComponents()
        if let hour = Int(components[0]), let minute = Int(components[1]) {
            dateComponents.hour = hour
            dateComponents.minute = minute
        }

        return AlarmNotification(
            IsAlarmOn: true, // флаг проверен заранее
            AlarmKey: type + "_" + time,
            AlarmType: type + "_" + time,
            NotificationContent: content,
            NotificationTime: dateComponents
        )
    }
    
    
    func IsTherapyActive(CurrentTherapyDay: String, TherapyDuration: String, TherapyDurations: [Int]) ->  Bool
    {
        let _isTharepyActive: Bool
        let _currentTherapyDay = UserDefaults.standard.integer(forKey: CurrentTherapyDay)
        let _therapyDuration = (TherapyDurations[UserDefaults.standard.integer(forKey: TherapyDuration)]*7) - 1
        
        _isTharepyActive = _currentTherapyDay <= _therapyDuration
        
        return _isTharepyActive
    }
    
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    // Показ уведомлений в форграунде
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Обработка действий
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "MUTE_10_MIN":
            let original = response.notification.request.content
            
            let content = UNMutableNotificationContent()
            content.title = original.title
            content.body = original.body
            content.sound = original.sound
            content.userInfo = original.userInfo
            content.categoryIdentifier = original.categoryIdentifier
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: false)
            let newId = response.notification.request.identifier + "_snooze"
            
            let request = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Ошибка при откладывании уведомления: \(error.localizedDescription)")
                } else {
                    print("🔔 Уведомление отложено на 10 минут")
                }
            }
            
        case "CANCEL_ACTION":
            let id = response.notification.request.identifier
            center.removePendingNotificationRequests(withIdentifiers: [id])
            print("❌ Уведомление отменено: \(id)")
            
        default:
            break
        }
        completionHandler()
    }
}

 struct AlarmNotification
{
     var IsAlarmOn: Bool
     var AlarmKey: String
     var AlarmType: String
     var NotificationContent: UNMutableNotificationContent
     var NotificationTime: DateComponents
}
