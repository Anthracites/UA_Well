import Foundation

class ExerciseManager {
    
    static let shared = ExerciseManager() // Singleton

    var Exercises: [Exercise] = []
   // private var exerciseDict: [Int: TemporaryExercise] = [:]
    private var exerciseData: [TemporaryExercise] = []
    var CurrentExercise: Exercise!
    var CurrentStep: Int = 0
    
    
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
                //print("Exercise data: ", exerciseData)
                var exerciseDict: [Int: TemporaryExercise] = [:]
                
                for exercise in exerciseData {
                    exerciseDict[exercise.Exercise_id!] = exercise
                }
                Exercises = CreateExercisesArray(tempArray: exerciseData, shareArray: Exercises)
                
                //print("Exercise 3 steps: ", Exercises[3].Steps?.count as Any)
                
                
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }

        }
        
    }
    private func TranslateExercises()
    {
        
    }
    
    
    private func CreateExercisesArray(tempArray: [TemporaryExercise?], shareArray: [Exercise?]) -> [Exercise]
    {
        var tempDict: [Int: TemporaryExercise] = [:]
        var shareArray: [Exercise] = []
        for _tempExercise in tempArray
        {
            tempDict[(_tempExercise?.Exercise_id)!] = _tempExercise
            //print (symptom.symptom_ID, symptom.symptom_name)
            }
        //print("Temp array: ", tempArray.count)
        
        var i: Int = 0
        
            for _exercise in tempArray
            {
                var _e = Exercise()
                _e.Exercise_id = _exercise?.Exercise_id
                _e.visualHint = _exercise?.Visual_hint
                _e.Steps = [Exercise.step()]
                
                if let steps = _exercise?.Steps
                {
                    var j: Int = 0
                    
                    for _s in steps
                    {
                        var st = Exercise.step()
                        
                        st.stepAction = _s.stepAction
                        st.stepNumber = _s.stepNumber
                        st.stepDuration = _s.stepDuration
                        
                        _e.Steps?.append(st)
                        j += 1
                    }
                }
                _e.ExerciseDuration = _exercise?.ExerciseDuration
                shareArray.append(_e)
                    i += 1
            }
        //print("Exercise 3 steps: ", shareArray[3].Steps?.count as Any)
        
        return shareArray
    }
}

private struct TemporaryExercise: Codable {
    var Exercise_id: Int?
    var ExerciseDuration: Int?
    var Visual_hint: Bool?
    var Steps: [step]?
    
    struct step: Codable{
        var stepNumber: Int?
        var stepAction: Int?
        var stepDuration: Float?
        
        enum CodingKeys: String, CodingKey
        {
            case stepNumber = "stepNumber"
            case stepAction = "stepAction"
            case stepDuration = "stepDuration"
        }
    }
        
        enum CodingKeys: String, CodingKey {
            case Exercise_id = "Exercise_id"
            case ExerciseDuration = "ExerciseDuration"
            case Visual_hint = "Visual_hint"
            case Steps = "Steps"
        }
}

