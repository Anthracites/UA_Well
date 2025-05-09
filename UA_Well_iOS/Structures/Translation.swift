import Foundation

public struct Translation: Codable {
    let currentLanguage: String?
    let commonButtons: CommonButtons?
    let prevention: Prevention?
    let aboutApplication: AboutApplication?
    let aboutUsAndcontactUs: AboutUsAndContactUs?
    let longTermWork: LongTermWork?
    
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
        
        let Return_to_language_selecttion_title: String
        let Return_to_day_selection_title: String
        let Return_to_parameters_title: String
        let Return_to_symptoms_title: String
        let Return_to_help_type_page_title: String
        
        
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
            
            case Return_to_language_selecttion_title = "Return_to_language_selecttion_title"
            case Return_to_day_selection_title = "Return_to_day_selection_title"
            case Return_to_parameters_title = "Return_to_parameters_title"
            case Return_to_symptoms_title = "Return_to_symptoms_title"
            case Return_to_help_type_page_title = "Return_to_help_type_page_title"
            
        }
    }
    
    struct Prevention:Codable{

        let Title: String
        let Description: String
        let IntesityLabel: String
        let DurationLabel: String
        let Intensivities: [Intensivity]
        let Durations:[Duration]
        
        struct Intensivity : Codable
        {
            let ID: Int
            let Name: String
            let Instruction: String
            
            enum CodingKeys:String, CodingKey
            {
                case ID = "ID"
                case Name = "Name"
                case Instruction = "Instruction"
            }
        }
        
        struct Duration : Codable
        {
            let ID: Int
            let Name: String
            
            enum CodingKeys:String, CodingKey
            {
                case ID = "ID"
                case Name = "Name"
            }
        }
        
    enum CodingKeys: String, CodingKey
    {
        case Title = "Title"
        case Description = "Description"
        case IntesityLabel = "IntesityLabel"
        case DurationLabel = "DurationLabel"
        case Intensivities = "Intensivities"
        case Durations = "Durations"
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
        let EmailTitle: String
        let EmailBody: String
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
            case EmailTitle = "EmailTitle"
            case EmailBody = "EmailBody"
            case SpecialistContacts = "SpecialistContacts"
        }
    }
    
    let HelpTypes: [HelpType]
    let Symptoms : [Symptom]
    let Exercises: [ExerciseTranslation]
    
    enum CodingKeys: String, CodingKey {
        case currentLanguage = "currentLanguage"
        case commonButtons = "commonButtons"
        case prevention = "prevention"
        case HelpTypes = "HelpTypes"
        case Symptoms = "Symptoms"
        case Exercises = "Exercises"
        case aboutApplication = "AboutApplication"
        case aboutUsAndcontactUs = "AboutUsAndContactUs"
        case longTermWork = "longTermWork"
    }
    
    struct LongTermWork: Codable {
        
        let Description: String
        let TherapyDays: [TherapyDay]
        
        struct TherapyDay : Codable
        {
            let TherapyPartID: Int
            let TherapyPartName: String
            let Instruction: String
            
            enum CodingKeys:String, CodingKey
            {
                case TherapyPartID = "DayID"
                case TherapyPartName = "TherapyPartName"
                case Instruction = "Instruction"
                
            }
        }
        
        enum CodingKeys: String, CodingKey {
            
            case Description = "Description"
            case TherapyDays = "TherapyDays"
            
        }
    }
    
    
}
