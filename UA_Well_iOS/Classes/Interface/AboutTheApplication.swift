import UIKit

class AboutTheApplication: UIViewController
{
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var appDescription: AutoResizingTextView!
    @IBOutlet weak var abouAppLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
    lazy var aboutAppTitle: String? = {TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppTitle}()
    lazy var aboutAppDescription: String? = {TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppDescription}()
    lazy var cachedExerciseTextHeight: CGFloat = {appDescription.adjustHeight(); return appDescription.frame.height }()
    
    private var layoutAlreadyConfigured = false
    
    lazy var cachedLayoutConstraint: NSLayoutConstraint? = {
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: generalView,
            title: abouAppLabel,
            exerciseText: appDescription,
            okButton: okButton
        )
        return LayoutConfigurator.configure(using: layoutConfig)
    }()
    

    private var exerciseTextHeightConstraint: NSLayoutConstraint?


        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            configureUI()
            configureLayout()
        }

        // MARK: - UI Setup
        private func configureUI() {
            abouAppLabel.text = aboutAppTitle
            appDescription.text = aboutAppDescription
            
            appDescription.isEditable = false
            appDescription.isSelectable = true
            appDescription.dataDetectorTypes = [.link]
            okButton.addTarget(self, action: #selector(okButtonHandler), for: .touchUpInside)
        }

        // MARK: - Layout Setup
        private func configureLayout() {
            guard !layoutAlreadyConfigured else { return }
            layoutAlreadyConfigured = true

            // Кэшируем высоту текста, если ещё не сохранена
            if cachedExerciseTextHeight == nil {
                appDescription.adjustHeight()
                cachedExerciseTextHeight = appDescription.frame.height
            }

            // Применяем высоту
            appDescription.frame.size.height = cachedExerciseTextHeight ?? appDescription.frame.height

            exerciseTextHeightConstraint = cachedLayoutConstraint
        }
    @objc func okButtonHandler()
    {
        dismiss(animated: true, completion: nil)
    }
    
    }
