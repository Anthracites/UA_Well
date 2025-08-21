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
       tableView.contentMode = .center
       tableView.contentSize = CGSize(width: tableView.frame.width, height: 200)

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 50
        return popUpButtonLabels.count
    }
    
    func TranslatedLabel(title: String) -> String
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
        
        let _buttonTitle = _buttonLabel.uppercased()
        return _buttonTitle
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let newButoon: UIButton = cell.MenuButton
        let label = popUpButtonLabels[indexPath.item]
//
        newButoon.accessibilityHint = label
        newButoon.setTitle(label, for: .normal)

        cell.contentMode = .center
//
        cell.contentView.contentMode = .center
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
         let title = TranslatedLabel(title: label)
        cell.copyButtonProperties(to: newButoon, label: title)
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
