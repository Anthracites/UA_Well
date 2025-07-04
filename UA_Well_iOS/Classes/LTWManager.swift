import Foundation

class LTWManager {
    
    static let shared = LTWManager() // Singleton
    var LTWDurations: [Int] = []
    var CurrentDuration: Int!
    var CurrentDay: Int!
    
    private init() {} // Закрытый инициализатор
    
    func initializeLTWManager() {
        guard LTWDurations.isEmpty else { return }
        GetParameters()
    }
    
    @objc func GetParameters()
    {
        if (UserDefaults.standard.integer(forKey: "LTWDuration") != nil)
        {
                        CurrentDuration = UserDefaults.standard.integer(forKey: "LTWDuration")
                        CurrentDay = UserDefaults.standard.integer(forKey: "LTWCurrentDay")
                    }
                        else
                    {
                            CurrentDuration = 0
                            CurrentDay = 0
                    }
                    print("Current duration: ", String(CurrentDuration))
        }
    }
