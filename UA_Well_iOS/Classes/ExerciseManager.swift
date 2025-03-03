import Foundation

class ExerciseManager {
    
    static let shared = ExerciseManager() // Singleton
    
    var Exercises: [Exercise] = []
    var CurrentExercise: Exercise!
    
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations()
    {
    }
}

