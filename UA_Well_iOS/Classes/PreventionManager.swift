import Foundation

class PreventionManager {
    
    static let shared = PreventionManager() // Singleton
    var PreventionDurations: [Int] = []
    var CurrentDuration: Int!
    var PreventionIntensities: [Int] = []
    var CurrentIntensity: Int!
    var CurrentDay: Int!
    
    private init() {} // Закрытый инициализатор
    
    func initializePreventionManager() {
        guard PreventionDurations.isEmpty else { return }
        GetParameters()
    }
    
    @objc func GetParameters()
    {
        if (UserDefaults.standard.integer(forKey: "PreventionDuration") != nil)
            {
            CurrentDuration = UserDefaults.standard.integer(forKey: "PreventionDuration")
            CurrentIntensity = UserDefaults.standard.integer(forKey: "PreventionIntensity")
            CurrentDay = UserDefaults.standard.integer(forKey: "PreventionCurrentDay")
        }
            else
        {
                CurrentDuration = 0
                CurrentIntensity = 0
                CurrentDay = 0
        }
        print("Current duration: ", String(CurrentDuration))
    }
}
