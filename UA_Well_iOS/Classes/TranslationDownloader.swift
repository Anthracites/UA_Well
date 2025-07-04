import Foundation
import UIKit

class TranslationDownloader {
    
    static let shared = TranslationDownloader() // Singleton
    
    var Translations: [Translation] = []
    var CurrentTranslation: Translation!
    var DefaultLanguage: Translation!
    var IsFirstRun: Bool!
    
    private init() {} // Закрытый инициализатор
    
    func initializeTranslations() {
        // Если массив translations уже не пустой, пропускаем загрузку
        guard Translations.isEmpty else { return }
        
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let translationsDirURL = documentsURL.appendingPathComponent("Content/translations")
        
        do
        {
            let fileURLs = try fileManager.contentsOfDirectory(at: translationsDirURL, includingPropertiesForKeys: nil).filter { $0.pathExtension == "json" }
            //print("Tranlaiting stareted from: ",  (fileURLs[0].path))
            for fileURL in fileURLs {
                do
                {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    let tempTranslations = try decoder.decode([TemporaryTranslation].self, from: data)
                    
                    var currentLanguage: String?
                    var commonButtons: Translation.CommonButtons?
                    var prevention: Translation.Prevention?
                    var aNotifications: Translation.AlarmNotifications?
                    var aboutApp: Translation.AboutApplication?
                    var aboutUs: Translation.AboutUsAndContactUs?
                    var helpTypes:[HelpType]? = []
                    var symptomsDict: [Int: Symptom] = [:]
                    var exercisesDict: [Int: ExerciseTranslation] = [:]
                    var longTermWork: Translation.LongTermWork?
                    
                    for tempTranslation in tempTranslations {
                        if let language = tempTranslation.currentLanguage {
                            currentLanguage = language
                        }
                        if let buttons = tempTranslation.commonButtons {
                            commonButtons = buttons
                        }
                        if let pr = tempTranslation.prevention {
                            prevention = pr
                        }
                        if let a = tempTranslation.alarmNotifications {
                            aNotifications = a
                        }
                        if let aboutApplicationt = tempTranslation.aboutApplication
                        {
                            aboutApp = aboutApplicationt
                        }
                        if let aboutUsAndcontactUs = tempTranslation.aboutUsAndcontactUs
                        {
                            aboutUs = aboutUsAndcontactUs
                        }

                        if let types = tempTranslation.HelpTypes{
                            helpTypes = types
                        }
                        if let symptoms = tempTranslation.Symptoms {
                            for symptom in symptoms
                            {
                                symptomsDict[symptom.symptom_ID] = symptom
                                //print (symptom.symptom_ID, symptom.symptom_name)
                                }
                        }
                        if let longWork = tempTranslation.longTermWork
                        {
                            longTermWork = longWork
                        }

                        if let exercises = tempTranslation.Exercises {
                            for exercise in exercises
                            {
                                exercisesDict[exercise.Exercise_ID] = exercise
                            }
                            
                            if let currentLanguage = currentLanguage, let commonButtons = commonButtons, let aNotifications = aNotifications, let prevention = prevention, let aboutApp = aboutApp,
                               let aboutUs = aboutUs, let longTermWork = longTermWork{
                                // Создаем массив Symptoms, отсортированный по symptom_ID
                                var symptomsArray = Array(symptomsDict.values)
                                symptomsArray.sort { $0.symptom_ID < $1.symptom_ID }
                                var exercisesArray = Array(exercisesDict.values)
                                exercisesArray.sort{ $0.Exercise_ID < $1.Exercise_ID }
                                
                                let translation = Translation(
                                    currentLanguage: currentLanguage,
                                    commonButtons: commonButtons,
                                    alarmNotifications: aNotifications,
                                    prevention: prevention,
                                    aboutApplication: aboutApp,
                                    aboutUsAndcontactUs: aboutUs,
                                    longTermWork: longTermWork,
                                    HelpTypes: helpTypes!,
                                    Symptoms: symptomsArray,
                                    Exercises: exercisesArray
                                )
                                if translation.currentLanguage == "Українська"
                                {
                                    DefaultLanguage = translation
                                    //print("Current langauge seleted!!!!")
                                }
                                
                                let savedLanguage = UserDefaults.standard.string(forKey: "Language")
                                
                                if savedLanguage != nil
                                {
                                    IsFirstRun = false
                                }
                                
                                if translation.currentLanguage == savedLanguage
                                {
                                    CurrentTranslation = translation
                                    print("Saved language: ", savedLanguage)
                                }

                                Translations.append(translation)
                            }
                        }
                    }
                    //print (" Translations success!", Translations[0].currentLanguage as Any)
//                    print("Translations directory path: \(fileURLs[0].path)")
                }
                catch
                {
                    //print("Ошибка парсинга", error)
                    //print("Ошибка подробнее", error.localizedDescription)
                    //print("Translations directory path: \(fileURLs[0].path)")
                }
            }
        }
                
                catch {
                    print("Ошибка при загрузке данных из файла ",translationsDirURL.path)
                }
            }
        }
    
    private struct TemporaryTranslation: Codable {
        let currentLanguage: String?
        let commonButtons: Translation.CommonButtons?
        let alarmNotifications: Translation.AlarmNotifications?
        let prevention: Translation.Prevention?
        let aboutApplication: Translation.AboutApplication?
        let aboutUsAndcontactUs: Translation.AboutUsAndContactUs?
        let HelpTypes: [HelpType]?
        let Symptoms: [Symptom]?
        let Exercises: [ExerciseTranslation]?
        let longTermWork: Translation.LongTermWork?
        
        enum CodingKeys: String, CodingKey {
            case currentLanguage
            case commonButtons = "commonButtons"
            case alarmNotifications = "alarmNotifications"
            case prevention = "prevention"
            case aboutApplication = "aboutApplication"
            case aboutUsAndcontactUs = "aboutUsAndcontactUs"
            case HelpTypes
            case Symptoms
            case Exercises
            case longTermWork = "longTermWork"
        }
    }
