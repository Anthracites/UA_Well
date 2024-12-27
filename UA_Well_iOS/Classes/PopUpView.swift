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
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let newButoon: UIButton = cell.MenuButton
        let label = popUpButtonLabels[indexPath.item]
        newButoon.setTitle(label, for:.normal)
        cell.contentView.contentMode = .center
        cell.copyButtonProperties(targetButton: newButoon)
        newButoon.addTarget(self, action: #selector(OnClickMenuButton), for: .touchUpInside)
        print("Cell added!")
        return cell
    }
    
    
    @objc func BackToPreviousScreen()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func OnClickMenuButton(_currentButton: UIButton)
    {
        if let _label = _currentButton.titleLabel?.text
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
