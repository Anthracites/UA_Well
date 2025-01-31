struct HelpExercises: Codable
{
    let symptom_ID: Int
    let help_exercise_array: [Int]
    
    enum CodingKeys:String, CodingKey
    {
        case symptom_ID
        case help_exercise_array
    }
}
