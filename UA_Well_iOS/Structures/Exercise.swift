
struct Exercise: Codable
{
        let symptom_ID: Int32;
        let symptom_name: String;
    let symptom_description: String;
        let help_exercise_array: [Int];
    
    enum CodingKeys:String, CodingKey
    {
        case symptom_ID
        case symptom_name
        case symptom_description
        case help_exercise_array = "help_exercise_array"
    }
}
