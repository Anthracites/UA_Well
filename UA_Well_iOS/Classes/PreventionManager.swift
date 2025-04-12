import Foundation

class PreventionManager {
    
    static let shared = PreventionManager() // Singleton
    var PreventionOptions: [String] = []
    
    private init() {} // Закрытый инициализатор
    
    func initializePreventionManager() {
        guard PreventionOptions.isEmpty else { return }
        PreventionOptions = ["Min", "Mid", "Max"]
    }
}
