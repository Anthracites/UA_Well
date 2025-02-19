import Foundation
import UIKit


class PopUpView:  UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var popUpButtonLabels: [String] = ["Main", "HelpTypesMenu", "AboutUsAndContactUs", "AboutTheApplication"]


    override func viewDidLoad()
    {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(BackToPreviousScreen), for: .touchUpInside)
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        tableView.contentMode = .center

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpButtonLabels.count
        
    }
    
    func Translate(currentButton: UIButton, title: String)
    {
        var _buttonLabel: String!
        
        switch  title{
        case "Main":
            _buttonLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons!.Languge_selection
            
        case "HelpTypesMenu":
            _buttonLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons!.Type_of_help
        case "AboutUsAndContactUs":
            _buttonLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons!.About_us_and_contact_us
        case "AboutTheApplication":
            _buttonLabel = TranslationDownloader.shared.CurrentTranslation.commonButtons!.About_the_application
        default:
            _buttonLabel = "button"
        }
        
        currentButton.setTitle(_buttonLabel, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let newButoon: UIButton = cell.MenuButton
        let label = popUpButtonLabels[indexPath.item]
        newButoon.setTitle(label, for: .normal)
        cell.contentView.contentMode = .center
        cell.copyButtonProperties(targetButton: newButoon)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        newButoon.accessibilityHint = label
        Translate(currentButton: newButoon, title: label)
        print("Cell added!")
        return cell
    }
    
    
    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func OnClickMenuButton(currentButton: UIButton)
    {
        if let _label = currentButton.accessibilityHint
        {
            print(String(_label))
            let storyboard = UIStoryboard(name: _label, bundle: nil)
            // Инициализируем ViewController
            let secondVC = storyboard.instantiateViewController(withIdentifier: _label)
            // Переход к новому ViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }

}
