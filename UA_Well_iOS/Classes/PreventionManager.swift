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
        GetParameters()
        GetConfig()
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
    
    @objc func GetConfig()
    {
        guard PreventionDurations.isEmpty else { return }

        if let url = Bundle.main.url(forResource: "PreventionConfig", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _preventionConfigData = try decoder.decode([PreventionConfig].self, from: data)
                //PreventionDurations = CreateExercisesArray(tempArray: exerciseData)
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }
}

private struct PreventionConfig: Codable {
    var Parametr_ID: Int?
    var Parametr_name: String?
    var Parametr_values: [Int?]

    enum CodingKeys: String, CodingKey {
        case Parametr_ID
        case Parametr_name
        case Parametr_values
    }
}
