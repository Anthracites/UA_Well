import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private var PreventionAlarmNotification, LTWAlarmNotification: AlarmNotification?
    
    private init() {}
    
    // Запрос разрешения на уведомления
    func requestAuthorization() {
        if (TranslationDownloader.shared.IsFirstRun == false)
        {
            registerNotificationCategories()
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        }
    }
    func scheduleNotifications() {
        registerNotificationCategories()

        if IsTherapyActive(CurrentTherapyDay: "LTWCurrentDay", TherapyDuration: "LTWDuration", TherapyDurations: LTWManager.shared.LTWDurations) {
            let times = ["12:00", "15:00", "18:00"]
            for time in times {
                let notification = createNotification(time: time, type: "LTWAlarm", screen: "LTWDayDescription", bodyKey: "Body_long_time_work", alarmKey: "LTWAlarm")
                scheduleNotification(_alarmNotification: notification)
            }
        } else {
            LTWManager.shared.ResetToDefault()
        }

        if IsTherapyActive(CurrentTherapyDay: "PreventionCurrentDay", TherapyDuration: "PreventionDuration", TherapyDurations: PreventionManager.shared.PreventionDurations) {
            let times = ["12:00", "15:00", "18:00"]
            var allTimes = times

            let intensity = UserDefaults.standard.integer(forKey: "PreventionIntensity") ?? 0
            if intensity == 1 || intensity == 2 {
                allTimes.append("21:00")
            }

            for time in allTimes {
                let notification = createNotification(time: time, type: "PreventionAlarm", screen: "PreventionInstruction", bodyKey: "Body_prevention", alarmKey: "PreventionAlarm")
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
    
    func createNotification(time: String, type: String, screen: String, bodyKey: String, alarmKey: String) -> AlarmNotification {
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

        let isAlarmOn = UserDefaults.standard.bool(forKey: alarmKey)

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
            IsAlarmOn: isAlarmOn,
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
 struct AlarmNotification
{
     var IsAlarmOn: Bool
     var AlarmKey: String
     var AlarmType: String
     var NotificationContent: UNMutableNotificationContent
     var NotificationTime: DateComponents
}
