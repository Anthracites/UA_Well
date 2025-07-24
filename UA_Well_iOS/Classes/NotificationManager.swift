import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private var PreventionAlarmNotification, LTWAlarmNotification: AlarmNotification?
    
    private init() {}
    
    // Запрос разрешения на уведомления
    func requestAuthorization() {
        registerNotificationCategories()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Разрешение получено")
//            } else {
//                print("Уведомления отключены")
//            }
        }
    }
    func scheduleNotifications()
    {
        PreventionAlarmNotification = GetNotificationParameters(_notificationType: "PreventionAlarm")
        LTWAlarmNotification = GetNotificationParameters(_notificationType: "LTWAlarm")
        
        if (IsTherapyActive(CurrentTherapyDay: "PreventionCurrentDay", TherapyDuration: "PreventionDuration") == true)
        {
            scheduleNotification(_alarmNotification: PreventionAlarmNotification!)
        }
        else
        {
            ResetToDefault()
        }
        
        //if (IsTherapyActive(CurrentTherapyDay: "PreventionCurrentDay", TherapyDuration: "PreventionDuration") == true)
        scheduleNotification(_alarmNotification: LTWAlarmNotification!)
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
            print("Error shedule notification:")
        }
    }
    
    func GetNotificationParameters(_notificationType: String) -> AlarmNotification {
        let _currentTranslation = TranslationDownloader.shared.CurrentTranslation
        let _notificationTitle = _currentTranslation?.alarmNotifications?.Title
        let _notificationBody: String
        var _notificationTime: String = "0:0"
        var _notificationScreen: String = "Main"
        var _notificationAlarmOn: String = "False"
        let _type = UserDefaults.standard.string(forKey: "IncomingNotificationType") ?? " "

        
        switch _notificationType {
        case "PreventionAlarm":
            _notificationBody = _currentTranslation?.alarmNotifications?.Body_prevention ?? " " + _type
            _notificationTime = "PreventionAlarmTime"
            _notificationScreen = "PreventionInstruction"
            _notificationAlarmOn = "PreventionAlarm"
        case "LTWAlarm":
            _notificationBody = _currentTranslation?.alarmNotifications?.Body_long_time_work ?? " " + _type
            _notificationTime = "LTWAlarmTime"
            _notificationScreen = "LTWDayDescription"
            _notificationAlarmOn = "LTWAlarm"
        default:
            _notificationBody = _currentTranslation?.alarmNotifications?.Body_prevention ?? " " + _type
        }
        
        let _isAlarmOn = UserDefaults.standard.bool(forKey: _notificationAlarmOn)
        
        let content = UNMutableNotificationContent()
        content.title = _notificationTitle ?? "Уведомление"
        content.body = _notificationBody
        content.sound = .default
        content.userInfo = ["screenID": _notificationType]
        content.categoryIdentifier = "ALARM_CATEGORY" // <- Добавляем кнопку-категорию

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let t = UserDefaults.standard.string(forKey: _notificationTime)
        var _alarmTime = DateComponents()
        if let t = t {
            let _timeComponents = t.split(separator: ":")
            if let hours = Int(_timeComponents[0]), let minutes = Int(_timeComponents[1]) {
                _alarmTime.hour = hours
                _alarmTime.minute = minutes
            }
        }
        
        let _notification = AlarmNotification(
            IsAlarmOn: _isAlarmOn,
            AlarmKey: _notificationType,
            AlarmType: _notificationType,
            NotificationContent: content,
            NotificationTime: _alarmTime
        )
        
        return _notification
    }
    
    func IsTherapyActive(CurrentTherapyDay: String, TherapyDuration: String) ->  Bool
    {
        let _isTharepyActive: Bool
        let _currentTherapyDay = UserDefaults.standard.integer(forKey: CurrentTherapyDay)
        let _therapyDuration = PreventionManager.shared.PreventionDurations[UserDefaults.standard.integer(forKey: TherapyDuration)]*7
        
        print("")
        
        _isTharepyActive = _currentTherapyDay <= _therapyDuration
        
        return _isTharepyActive
    }
    
    @objc func ResetToDefault()
    {
        UserDefaults.standard.set(nil, forKey: "PreventionAlarm")
        UserDefaults.standard.set(nil, forKey: "PreventionAlarmTime")
        UserDefaults.standard.set(nil, forKey: "PreventionDuration")
        UserDefaults.standard.set(nil, forKey: "PreventionIntensity")
        UserDefaults.standard.set(nil, forKey: "PreventionCurrentDay")
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
