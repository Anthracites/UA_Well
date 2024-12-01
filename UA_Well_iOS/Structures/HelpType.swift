
struct HelpType: Codable
{
        let help_type_id: Int32;
        let help_type_name: String;
    
    enum CodingKeys:String, CodingKey
    {
        case help_type_id
        case help_type_name
    }
}
