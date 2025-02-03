struct Exercise: Codable
{
    let Exercise_ID: Int
    let description: String
    let name: String
    
    enum CodingKeys:String, CodingKey
    {
        case Exercise_ID
        case description
        case name
    }
}
