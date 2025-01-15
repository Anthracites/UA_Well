//
//  LocalData.swift
//  UA_Well_iOS
//
//  Created by Наталья Гусарова on 24.09.2024.
//

import Foundation

struct Translation
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
    }
    
    struct Language_selection_screen
    {
        var return_page_title: String;
        var title: String;
    }
    
    struct Therapy_options_screen
    {
        var quick_help: String;
        var long_term_work: String;
        var prevention: String;
        var return_page_title: String;
        var title: String;
    }
    
    struct About_app_screen
    {
        var title: String;
        var description: String;
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
            }
        }
        
        struct Prevention
        {
             
        }
    }
}
