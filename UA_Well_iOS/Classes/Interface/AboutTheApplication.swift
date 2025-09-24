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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let newVC = ScreenCache.shared.viewController(named: "PopUpView", storyboardName: "PopUpView")
            window.rootViewController = newVC
            window.makeKeyAndVisible()
        }

    }
    
    func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self {
                // Если VC не корневой — можно сделать pop
                navigationController.popViewController(animated: animated)
                completion?()
                return
            }
        }

        if presentingViewController != nil {
            // Если VC был представлен модально — dismiss
            dismiss(animated: animated, completion: completion)
            return
        }

        print("❌ Невозможно закрыть экран: не модальный и не в навигации")
        completion?()
    }

    
    
    }


