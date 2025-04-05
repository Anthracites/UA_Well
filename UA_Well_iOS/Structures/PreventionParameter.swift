
struct PreventionParameter: Codable
{
    let Parametr_ID: Int;
    let Parametr_name: String;
    let Parametr_values: [String];
    
    enum CodingKeys:String, CodingKey
    {
        case Parametr_ID
        case Parametr_name
        case Parametr_values
    }
}
