import UIKit

class LaunchScreen: UIViewController {

    let logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        animatePulsing()
    }

    func animatePulsing() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
}
