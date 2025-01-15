// Structures
struct Translation: Codable
{
    var currentLanguage:String;
    
    struct Common_button
    {
        var Start: String;
        var Next:String;
        var start_over: String;
        var it_helped: String;
        var contact_specialist: String;
        var alarm: String;
        var ok: String;
        
        enum CodingKeys:String, CodingKey
        {
            case Start
            case Next
            case start_over
            case it_helped
            case contact_specialist
            case alarm
            case ok
        }
        
    }
    
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
    
    enum CodingKeys:String, CodingKey
    {
        
        case currentLanguage
        
    }
}

