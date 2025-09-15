import UIKit

class AboutTheApplication: UIViewController
{
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var appDescription: AutoResizingTextView!
    @IBOutlet weak var abouAppLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
    private var exerciseTextHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        translateView()
        appDescription.isEditable = false
        appDescription.isSelectable = true
        appDescription.dataDetectorTypes = [.link]
        okButton.addTarget(self, action: #selector(okButtonHandler), for: .touchUpInside)
        appDescription.adjustHeight()
    }
    private func configureLayout()
    {
        appDescription.adjustHeight()
        
        let layoutConfig = LayoutConfigurator.Config(
            parentView: view,
            header: header,
            scrollView: scrollView,
            contentView: generalView,
            title:abouAppLabel, exerciseText: appDescription,
            okButton: okButton
        )
        exerciseTextHeightConstraint = LayoutConfigurator.configure(using: layoutConfig)
    }
    
@objc func translateView()
    {
        guard ((TranslationDownloader.shared.CurrentTranslation.currentLanguage?.isEmpty) != nil)  else { return }
        appDescription.text = TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppDescription
        abouAppLabel.text = TranslationDownloader.shared.CurrentTranslation.aboutApplication?.AboutAppTitle
    }
    
    @objc func okButtonHandler()
    {
        dismiss(animated: true, completion: nil)
    }
}
