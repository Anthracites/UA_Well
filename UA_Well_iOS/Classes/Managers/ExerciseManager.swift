import Foundation

class ExerciseManager {
    
    static let shared = ExerciseManager() // Singleton
    
    var Exercises: [Exercise] = []
    var CurrentExercise: Exercise!
    var CurrentStep: Int = 0
    var CurrentHelpType: String!
    var HelpTypes: [HelpType] = []
    var QuickHelpExercises: [HelpExercises] = []
    var PreventionParameters: [PreventionParameter] = []
    var IsAppOpenFromNotification: Bool! = false
    var NotificationType:String?
    var PreviousViewName: String?
    
    private init() {} // Закрытый инициализатор
    
    func initializeExercises() {
        guard Exercises.isEmpty else { return }
        
        if let url = Bundle.main.url(forResource: "Exercises", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                Exercises = try decoder.decode([Exercise].self, from: data)
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
        guard HelpTypes.isEmpty else { return }
        
        GetExersices()
        GetHelpTypes()
        GetPreventionParameters()
    }
    
    private func GetPreventionParameters()
    {
        if
            let url = Bundle.main.url(forResource: "PreventionConfig", withExtension: "json")
        {
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _preventionParameter = try decoder.decode([PreventionParameter].self, from: data)
                PreventionParameters = _preventionParameter
                
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }
    
    private func GetHelpTypes()
    {
        if
            let url = Bundle.main.url(forResource: "HelpTypes", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let helpType = try decoder.decode([HelpType].self, from: data)
                HelpTypes = helpType
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }
    
    @objc func GetExersices()
    {
        if
            let url = Bundle.main.url(forResource: "Quick_help_exercise", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exerciseData = try decoder.decode([HelpExercises].self, from: data)
                var exerciseDict: [Int: HelpExercises] = [:]
                for exercise in exerciseData {
                    exerciseDict[exercise.symptom_ID] = exercise
                }
                
                QuickHelpExercises = exerciseData
                
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }
}
