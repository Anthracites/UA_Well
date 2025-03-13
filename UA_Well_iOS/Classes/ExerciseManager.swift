import Foundation

class ExerciseManager {

    static let shared = ExerciseManager() // Singleton

    var Exercises: [Exercise] = []
    private var exerciseData: [TemporaryExercise] = []
    var CurrentExercise: Exercise!
    var CurrentStep: Int = 0

    private init() {} // Закрытый инициализатор

    func initializeExercises() {
        guard Exercises.isEmpty else { return }

        if let url = Bundle.main.url(forResource: "Exercises", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exerciseData = try decoder.decode([TemporaryExercise].self, from: data)
                Exercises = CreateExercisesArray(tempArray: exerciseData)
            } catch {
                print("Ошибка при загрузке данных: \(error)")
            }
        }
    }

    private func CreateExercisesArray(tempArray: [TemporaryExercise]) -> [Exercise] {
        var shareArray: [Exercise] = []
        for _tempExercise in tempArray {
            let _e = Exercise(
                Exercise_id: _tempExercise.Exercise_id,
                ExerciseDuration: _tempExercise.ExerciseDuration,
                Visual_hint: _tempExercise.Visual_hint,
                StepsSubsequence: _tempExercise.StepsSubsequence,
                StepsDurations: _tempExercise.StepsDurations
            )
            shareArray.append(_e)
        }
        return shareArray
    }
}

private struct TemporaryExercise: Codable {
    var Exercise_id: Int?
    var ExerciseDuration: Int?
    var Visual_hint: Bool?
    var StepsSubsequence: String?
    var StepsDurations: String?

    enum CodingKeys: String, CodingKey {
        case Exercise_id
        case ExerciseDuration
        case Visual_hint
        case StepsSubsequence
        case StepsDurations
    }
}
