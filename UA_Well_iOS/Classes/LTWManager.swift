import Foundation

class LTWManager {
    
    static let shared = LTWManager() // Singleton
    var LTWDurations: [Int] = []
    var CurrentDuration: Int!
    var CurrentDay: Int!
    var DayCount: Int!
    var IsLTWExerciseCompletedToday: Bool!

    
    private init() {} // Закрытый инициализатор
    
    func initializeLTWManager() {
        guard LTWDurations.isEmpty else { return }
        GetParameters()
        
        print ("Current prevention day in LTWManager = ", String(CurrentDay))
    }
    
    @objc func GetParameters()
    {
        LTWDurations = [2,2,2]
        if (UserDefaults.standard.integer(forKey: "LTWDuration") != nil)
        {
                        CurrentDuration = UserDefaults.standard.integer(forKey: "LTWDuration")
            DayCount = UserDefaults.standard.integer(forKey: "LTWCurrentDay")
                    }
                        else
                    {
                            CurrentDuration = 1
                            DayCount = 0
                    }
        SwitchDayID()
                    print("Current day count LTW: ", String(CurrentDay))
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
