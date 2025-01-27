import Foundation
import UIKit

class QuickHelpManager {
    
    static let shared = QuickHelpManager() // Singleton
    
    var Exercises: [Exercise] = []
    var CurrentSyptom: Exercise!
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations()
    {
    }
}
