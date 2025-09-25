import UIKit

extension UIViewController {
    func trackAsCurrentScreen() {
        ScreenCache.shared.previousVC = self
    }
}
