import Foundation

class ExerciseManager {
    
    static let shared = ExerciseManager() // Singleton

    var Exercises: [Exercise] = []
    var CurrentExercise: Exercise!
    
    
    private init() {} // Закрытый инициализатор
    

    
    func initializeExercises()
    {
        guard Exercises.isEmpty else { return }
        
        if
            let url = Bundle.main.url(forResource: "Exercises", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exerciseData = try decoder.decode([TemporaryExercise].self, from: data)
                // print(exerciseData)
                var exerciseDict: [Int: TemporaryExercise] = [:]
                for exercise in exerciseData {
                    exerciseDict[exercise.Exercise_id!] = exercise
                    //print(exerciseDict)
                }
                
                //quickHelpExercises = exerciseData
                
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
        
    }
    
    private func CreateExercisesArray(tempArray: [TemporaryExercise?], shareArray: [Exercise?])
    {
        var tempDict: [Int: TemporaryExercise] = [:]
        var shareArray: [Exercise] = []
        for _tempExercise in tempArray
        {
            tempDict[(_tempExercise?.Exercise_id)!] = _tempExercise
            //print (symptom.symptom_ID, symptom.symptom_name)
            }
        
        var i: Int = 0
        
            for _exercise in tempDict
            {
                shareArray[i].Exercise_id = (_exercise.value.Exercise_id)!
                shareArray[i].visualHint = (_exercise.value.visualHint)!
//                var _tempStep: = []
//                var j: Int = 0
//                for step in _exercise
//                {
//                    
//                }
//                shareArray[i].steps = (_exercise.value.steps)!
                i += 1
            }
    }
}

private struct TemporaryExercise: Codable {
    var Exercise_id: Int?
    var visualHint: Bool?
    var steps: [step]?
    
    struct step: Codable{
        var stepNumber: Int?
        var stepAction: String?
        var stepDuration: Float?
        
        enum CodingKeys: String, CodingKey
        {
            case stepNumber
            case stepAction
            case stepDuration
        }
    }
        
        enum CodingKeys: String, CodingKey {
            case Exercise_id = "Exercise_id"
            case visualHint = "visualHint"
            case steps
        }
}

