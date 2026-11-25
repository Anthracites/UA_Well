enum AppBootstrap {
    static func start() {
        TranslationFileManager.shared.prepareTranslations()
        TranslationDownloader.shared.initializeTranslations()
        ExerciseManager.shared.initializeExercises()
        PreventionManager.shared.initializePreventionManager()
        LTWManager.shared.initializeLTWManager()

        TranslationDownloader.shared.IsFirstRun = true

        if let translation = TranslationDownloader.shared.CurrentTranslation {
            QuickHelpManager.shared.Symtoms = translation.Symptoms
        }
    }
}
