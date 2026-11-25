struct Exercise: Decodable {
    let ExerciseId: Int
    let ExerciseDuration: Int
    let VisualHint: Bool
    let Steps: [Step]

    struct Step {
        let num: Int
        let action: Int
        let duration: Int
    }

    enum CodingKeys: String, CodingKey {
        case ExerciseId = "Exercise_id"
        case ExerciseDuration
        case VisualHint = "Visual_hint"
        case StepsSubsequence
        case StepsDurations
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        ExerciseId = try c.decode(Int.self, forKey: .ExerciseId)
        ExerciseDuration = try c.decode(Int.self, forKey: .ExerciseDuration)
        VisualHint = try c.decode(Bool.self, forKey: .VisualHint)

        let actions = try c.decode(String.self, forKey: .StepsSubsequence)
            .split(separator: ",").compactMap { Int($0) }
        let times = try c.decode(String.self, forKey: .StepsDurations)
            .split(separator: ",").compactMap { Int($0) }

        Steps = zip(actions, times).enumerated().map {
            Step(num: $0.offset, action: $0.element.0, duration: $0.element.1)
        }
    }
}
