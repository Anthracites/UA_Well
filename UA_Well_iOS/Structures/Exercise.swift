import Foundation

 struct Exercise: Codable {
    var Exercise_id: Int?
    var ExerciseDuration: Int?
    var Visual_hint: Bool?
    var Steps: [Step]?
    
    var StepsSubsequence: String?
    var StepsDurations: String?
    
    enum CodingKeys: String, CodingKey {
        case Exercise_id
        case ExerciseDuration
        case Visual_hint
        case StepsSubsequence
        case StepsDurations
        case Steps
    }
    
    init(Exercise_id: Int?, ExerciseDuration: Int?, Visual_hint: Bool?, StepsSubsequence: String?, StepsDurations: String?) {
        self.Exercise_id = Exercise_id
        self.ExerciseDuration = ExerciseDuration
        self.Visual_hint = Visual_hint
        self.StepsSubsequence = StepsSubsequence
        self.StepsDurations = StepsDurations
        self.Steps = zip(StepsSubsequence?.split(separator: ",").compactMap { Int($0) } ?? [],
                         StepsDurations?.split(separator: ",").compactMap { Int($0) } ?? []).enumerated().map { index, pair in
            return Step(num: index, action: pair.0, duration: pair.1)
        }
    }

    struct Step: Codable {
        var num: Int
        var action: Int
        var duration: Int

        enum CodingKeys: String, CodingKey {
            case num
            case action
            case duration
        }
    }
}
