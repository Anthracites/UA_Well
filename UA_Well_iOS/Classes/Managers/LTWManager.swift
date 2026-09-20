import Foundation

class LTWManager {
    
    static let shared = LTWManager() // Singleton
    var LTWDurations = [2,2,2,2,2]
    var CurrentDuration: Int!
    var CurrentDay: Int!
    var DayCount: Int!
    var IsLTWExerciseCompletedToday: Bool!

    
    private init() {} // Закрытый инициализатор
    
    func initializeLTWManager() {
        guard DayCount == nil else { return }
        GetParameters()
    }
    
    @objc func GetParameters()
    {
        // UserDefaults.integer(forKey:) never returns nil (defaults to 0 when the
        // key is missing), so this needs object(forKey:) to actually detect
        // "no saved progress yet" vs. "day 0 was saved".
        if UserDefaults.standard.object(forKey: "LTWCurrentDay") != nil
        {
            DayCount = UserDefaults.standard.integer(forKey: "LTWCurrentDay")
        }
        else
        {
            DayCount = 0
        }

        // Same idea for the saved duration: only fall back to the default (2,
        // matching LTWDurations) when nothing was ever saved. Previously this
        // was unconditionally overwritten with 2 right after being read,
        // silently discarding whatever duration the user picked on
        // LTWDayDescription.
        if let savedDuration = UserDefaults.standard.object(forKey: "LTWDuration") as? Int
        {
            CurrentDuration = savedDuration
        }
        else
        {
            CurrentDuration = 2
        }

        SwitchDayID()
    }
    @objc func SwitchDayID()
    {
        
        guard let _dayCount = DayCount else {
            return
        }
        
        switch _dayCount{
        case 0...4:
            CurrentDay = 0
        case 5...9:
            CurrentDay = 1
        case 10...14:
            CurrentDay = 2
        case 15:
            CurrentDay = 3
        default:
            CurrentDay = 0
        }
    }
    
    @objc func ResetToDefault()
    {
        UserDefaults.standard.set(nil, forKey: "LTWCurrentDay")
        UserDefaults.standard.set(nil, forKey: "LTWAlarm")
        UserDefaults.standard.set(nil, forKey: "LTWDuration")
        UserDefaults.standard.set(nil, forKey: "LTWAlarmTime")
    }
    
    }
