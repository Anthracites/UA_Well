import UIKit

extension UIApplication {

    /// Replaces the key window's root view controller.
    ///
    /// This is the pattern used for full-screen transitions between
    /// storyboard scenes that aren't pushed onto a navigation stack
    /// (e.g. swapping the entire visible screen instead of presenting
    /// modally or pushing).
    ///
    /// - Parameters:
    ///   - viewController: The view controller to make the new root.
    ///   - animated: When `true`, crossfades to the new root instead of
    ///     swapping instantly. Defaults to `false` to match plain
    ///     `window.rootViewController = viewController` behavior.
    ///   - duration: Crossfade duration, used only when `animated` is `true`.
    func setRootViewController(
        _ viewController: UIViewController,
        animated: Bool = false,
        duration: TimeInterval = 0.3
    ) {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        guard animated else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }

        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = viewController
            }
        )
        window.makeKeyAndVisible()
    }
}
