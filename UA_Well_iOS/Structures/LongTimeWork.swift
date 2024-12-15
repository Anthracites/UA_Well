struct LongTimeWork: Codable
{
        let Day_number: Int32;
        let buttonLabel: String;
        let help_exercise_array: [Int];
    
    enum CodingKeys:String, CodingKey
    {
        case Day_number
        case buttonLabel
        case help_exercise_array = "help_exercise_array"
    }
}

