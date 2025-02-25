import Foundation

class QuickHelpManager {
    
    static let shared = QuickHelpManager() // Singleton
    
    var Symtoms: [Symptom] = []
    var CurrentSyptom: Symptom!
    var CurrentExersicesArray: [Int]!
    var CurrentExercise: Int!
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations()
    {
    }
}
