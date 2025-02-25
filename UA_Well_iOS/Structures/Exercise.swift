struct Exercise: Codable
{
    let Exercise_ID: Int
    let description: String
    let name: String
    let visualHint: Bool
    let steps: [step]
    
    struct step: Codable{
        let stepNumber: Int
        let stepAction: String
        let stepDuration: Float
        
        enum CodingKeys: String, CodingKey
        {
            case stepNumber
            case stepAction
            case stepDuration
        }
    }
    enum CodingKeys:String, CodingKey
    {
        case Exercise_ID
        case description
        case name
        case visualHint
        case steps
    }
}


