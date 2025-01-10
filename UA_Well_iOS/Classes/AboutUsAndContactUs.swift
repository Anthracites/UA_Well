import UIKit
import Foundation

class AboutUsAndContactUs: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentViews: [UIView]!
    @IBOutlet var generalView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        okButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        // Установка contentSize для UIScrollView
        ScrollSetup()
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
