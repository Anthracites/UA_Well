struct Exercise: Codable
{
    var Exercise_id: Int
    var description: String
    var name: String
    var visualHint: Bool
    var steps: [step]
    
    struct step: Codable{
        var stepNumber: Int
        var stepAction: String
        var stepDuration: Float
        
        enum CodingKeys: String, CodingKey
        {
            case stepNumber
            case stepAction
            case stepDuration
        }
    }
    enum CodingKeys:String, CodingKey
    {
        case Exercise_id
        case description
        case name
        case visualHint
        case steps
    }
}


