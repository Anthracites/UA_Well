import Foundation

public struct Translation: Codable {
    let currentLanguage: String
    let commonButtons: CommonButtons?
    let aboutApplication: AboutApplication?
    let aboutUsAndcontactUs: AboutUsAndContactUs?
    
    struct CommonButtons: Codable {
        let Start: String
        let Next: String
        let Start_over: String
        let It_helped: String
        let Contact_specialist: String
        let Alarm: String
        let Ok: String
        let Languge_selection: String
        let Type_of_help: String
        let About_us_and_contact_us: String
        let About_the_application: String

        
        
        enum CodingKeys: String, CodingKey {
            case Start = "Start"
            case Next = "Next"
            case Start_over = "Start_over"
            case It_helped = "It_helped"
            case Contact_specialist = "Contact_specialist"
            case Alarm = "Alarm"
            case Ok = "Ok"
            case Languge_selection = "Languge_selection"
            case Type_of_help = "Type_of_help"
            case About_us_and_contact_us = "About_us_and_contact_us"
            case About_the_application = "About_the_application"

        }
    }
    
    
    struct AboutApplication: Codable {
        
            let AboutAppTitle: String
            let AboutAppDescription: String
            
            enum CodingKeys:String, CodingKey
            {
                case AboutAppTitle = "AboutAppTitle"
                case AboutAppDescription = "AboutAppDescription"
            }
    }
    
    struct AboutUsAndContactUs: Codable{
        
        let Title: String
        let Description: String
        let LanguagesLabel: String
        let ContactsLabel: String
        let TechDecription: String
        let SpecialistContacts: [SpecialistContact]
        
        struct SpecialistContact : Codable
        {
            let SpecialistName: String
            let SpecialistSurname: String
            let AvalibleLanguages: String
            let Description: String
            let Contacts: [Contact]
            
            struct Contact: Codable{
                let UrlMask: String
                let UrlContact: String
                
                enum CodingKeys:String, CodingKey
                {
                    case UrlMask
                    case UrlContact
                }
            }
            
            enum CodingKeys: String, CodingKey
            {
                case SpecialistName = "SpecialistName"
                case SpecialistSurname = "SpecialistSurname"
                case AvalibleLanguages = "AvalibleLanguages"
                case Contacts = "Contacts"
                case Description = "Description"
            }
        }
        
        enum CodingKeys:String, CodingKey
        {
            case Title = "Title"
            case Description = "Description"
            case LanguagesLabel = "LanguagesLabel"
            case ContactsLabel = "ContactsLabel"
            case TechDecription = "TechDecription"
            case SpecialistContacts = "SpecialistContacts"
        }
    }
    
    let HelpTypes: [HelpType]
    let Symptoms : [Symptom]
    let Exercises: [ExerciseTranslation]
    
    enum CodingKeys: String, CodingKey {
        case currentLanguage = "currentLanguage"
        case commonButtons = "Common_buttons"
        case HelpTypes = "HelpTypes"
        case Symptoms = "Symptoms"
        case Exercises = "Exercises"
        case aboutApplication = "AboutApplication"
        case aboutUsAndcontactUs = "AboutUsAndContactUs"
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

