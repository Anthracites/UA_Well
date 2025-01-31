
struct Symptom: Codable
{
    let symptom_ID: Int32;
    let symptom_name: String;
    let symptom_description: String;
    
    enum CodingKeys:String, CodingKey
    {
        case symptom_ID
        case symptom_name
        case symptom_description
    }
}
