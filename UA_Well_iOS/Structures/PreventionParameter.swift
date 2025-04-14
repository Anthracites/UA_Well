
struct PreventionParameter: Codable
{
    let Parametr_ID: Int;
    let Parametr_name: String?;
    let Parametr_values: [Int];
    
    enum CodingKeys:String, CodingKey
    {
        case Parametr_ID = "Parametr_ID"
        case Parametr_name = "Parametr_name"
        case Parametr_values = "Parametr_values"
    }
}
