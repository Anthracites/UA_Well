import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentViews: [UIView]!
    @IBOutlet var generalView: UIView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewDescription: UITextView!
    @IBOutlet weak var languageLabel_1, languageLabel_2: UILabel!
    @IBOutlet weak var contactLabel_1, contactLabel_2: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        okButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        // Установка contentSize для UIScrollView
        TranslateView()
        ScrollSetup()
    }
    @objc func TranslateView()
    {
        let _translation = TranslationDownloader.shared.CurrentTranslation
        viewTitle.text = _translation?.aboutUsAndcontactUs?.Title
        viewDescription.text = _translation?.aboutUsAndcontactUs?.Description
        languageLabel_1.text = _translation?.aboutUsAndcontactUs?.LanguagesLabel
        languageLabel_2.text = _translation?.aboutUsAndcontactUs?.LanguagesLabel
        contactLabel_1.text = _translation?.aboutUsAndcontactUs?.ContactsLabel
        contactLabel_2.text = _translation?.aboutUsAndcontactUs?.ContactsLabel
        
        
        
    }
    
    @objc func ScrollSetup()
    {
    
        scrollView.contentSize = CGSize(width: generalView.frame.width, height: generalView.frame.height)

        // Отключение горизонтальной прокрутки
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        // Установка contentInsetAdjustmentBehavior
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }

}
