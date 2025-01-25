import Foundation

public struct Translation: Codable {
    let currentLanguage: String
    let commonButtons: CommonButtons?

    
    struct CommonButtons: Codable {
        let Start: String
        let Next: String
        let Start_over: String
        let It_helped: String
        let Contact_specialist: String
        let Alarm: String
        let Ok: String
        
        enum CodingKeys: String, CodingKey {
            case Start = "Start"
            case Next = "Next"
            case Start_over = "Start_over"
            case It_helped = "It_helped"
            case Contact_specialist = "Contact_specialist"
            case Alarm = "Alarm"
            case Ok = "Ok"
        }
    }
    
    let HelpTypes: [HelpType]
    
    enum CodingKeys: String, CodingKey {
        case currentLanguage = "currentLanguage"
        case commonButtons = "Common_buttons"
        case HelpTypes = "HelpTypes"
    }


    /*
    struct Language_selection_screen
    {
        var return_page_title: String;
        var title: String;
        
        enum CodingKeys:String, CodingKey
        {
            case return_page_title
            case title
        }
    }
    
    struct Therapy_options_screen
    {
        var quick_help: String;
        var long_term_work: String;
        var prevention: String;
        var return_page_title: String;
        var title: String;
        
        enum CodingKeys:String, CodingKey
        {
            case quick_help
            case long_term_work
            case prevention
            case return_page_title
            case title
        }
    }
    
    struct About_app_screen
    {
        var title: String;
        var description: String;
        
        enum CodingKeys:String, CodingKey
        {
            case title
            case description
        }
    }
    
    struct Contacts_screen
    {
        var title: String;
        var description: String;
        var language_title: String;
        var contacts_title: String;
        
        struct Contascts
        {
            var name:String;
            var surname:String;
            var languages:String;
            var description:String;
            var email:String;
            var youtube:String;
            
            enum CodingKeys:String, CodingKey
            {
                case name
                case surname
                case languages
                case description
                case email
                case youtube
            }
        }
        
        enum CodingKeys:String, CodingKey
        {
            case title
            case description
            case language_title
            case contacts_title
        }
        
    }
    
    struct   LongTermWork
    {
        var TherapyType:String;
        var TherapyTypeID:Int32;
        var TherapyDescriptio:String;
        
        struct TherapyDay
        {
            var Day_number: Int32;
            var DayLabel: String;
            var Instruction: String;
            
            enum CodingKeys:String, CodingKey
            {
                case Day_number
                case DayLabel
                case Instruction
            }
        }
        enum CodingKeys:String, CodingKey
        {
            case TherapyType
            case TherapyTypeID
            case TherapyDescriptio
        }
    }
    // Deserialization
     */


}

