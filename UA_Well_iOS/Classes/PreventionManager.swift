import Foundation

class PreventionManager {
    
    static let shared = PreventionManager() // Singleton
    var PreventionDurations: [Int] = []
    var CurrentDuration: Int!
    var PreventionSensities: [Int] = []
    var CurrentSensity: Int!
    
    private init() {} // Закрытый инициализатор
    
    func initializePreventionManager() {
        guard PreventionDurations.isEmpty else { return }
    }
}
