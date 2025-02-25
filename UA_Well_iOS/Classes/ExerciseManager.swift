import Foundation

class ExerciseManager {
    
    static let shared = ExerciseManager() // Singleton
    
    var Exercises: [Exercise] = []
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations()
    {
    }
}

