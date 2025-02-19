struct VisualHintExercise: Codable
{
    let Exercise_ID: Int
    let Visual_hint: Bool
    
    enum CodingKeys:String, CodingKey
    {
        case Exercise_ID
        case Visual_hint
    }
}
