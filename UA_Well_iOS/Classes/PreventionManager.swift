import Foundation

class PreventionManager {
    
    static let shared = PreventionManager() // Singleton
    private var PreventionConfigs: [PreventionConfig] = []
    var PreventionDurations: [Int] = []
    var CurrentDuration: Int!
    var PreventionIntensities: [Int] = []
    var CurrentIntensity: Int!
    var CurrentDay: Int!
    
    private init() {} // Закрытый инициализатор
    
    func initializePreventionManager() {
        guard PreventionDurations.isEmpty else { return }
        GetConfig()
        GetParameters()
    }
    
    @objc func GetParameters()
    {
        if (UserDefaults.standard.integer(forKey: "PreventionDuration") != nil)
            {
            let d = UserDefaults.standard.integer(forKey: "PreventionDuration")
            let i = UserDefaults.standard.integer(forKey: "PreventionIntensity")
            
            CurrentDuration = d
            CurrentIntensity = i
            CurrentDay = UserDefaults.standard.integer(forKey: "PreventionCurrentDay")
        }
            else
        {
                CurrentDuration = 0
                CurrentIntensity = 0
                CurrentDay = 1
                print("Error of get perevention parameters from UserDefaul!!!")
        }
        print("Current duration in PreventionManager: ", String(CurrentDuration))
        print ("Current prevention day in PreventionManager = ", String(CurrentDay))
    }
    
    @objc func GetConfig()
    {
        guard PreventionDurations.isEmpty else { return }

        if let url = Bundle.main.url(forResource: "PreventionConfig", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _preventionConfigData = try decoder.decode([PreventionConfig].self, from: data)
                PreventionConfigs = _preventionConfigData
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
        PreventionDurations = PreventionConfigs[1].Parametr_values
        PreventionIntensities = PreventionConfigs[0].Parametr_values
    }
}

private struct PreventionConfig: Codable {
    var Parametr_ID: Int?
    var Parametr_name: String?
    var Parametr_values: [Int]

    enum CodingKeys: String, CodingKey {
        case Parametr_ID
        case Parametr_name
        case Parametr_values
    }
}
