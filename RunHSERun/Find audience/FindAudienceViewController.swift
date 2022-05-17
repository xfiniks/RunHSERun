import Foundation
import UIKit

protocol ApiSearchRoomsLogic {
    func moveToRegistration()
    func updateTable()
    func showAlert(message : String)
    func openWaitingScreen()
}

class FindAudienceViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        ApiManager.shared.findAudienceViewController = self
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiManager.shared.getRoomsByPatternRequest(pattern: "")
//        ApiManager.shared.filteredRooms = ApiManager.shared.rooms
    }
    

    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 15
        searchBar.placeholder = "Enter an audience number..."
        searchBar.showsCancelButton = false
        return searchBar
    } ()
    
    
    private lazy var searchlabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .cyan
        label.textAlignment = .center
        label.text = "Enter your audience"
        label.font = label.font.withSize(30)
        label.textColor = .systemBlue
        return label
    } ()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(AudienceCell.self, forCellReuseIdentifier: AudienceCell.indentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = .zero
        } else {
            // Fallback on earlier versions
        }
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private func configureUI() {
        view.addSubview(searchlabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchlabel.widthAnchor.constraint(equalToConstant: 270),
            searchlabel.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: searchlabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FindAudienceViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ApiManager.shared.filteredRooms.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = ApiManager.shared.filteredRooms[indexPath.row].code
        GameParameters.game.audience = ApiManager.shared.filteredRooms[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudienceCell.indentifier, for: indexPath) as! AudienceCell
        
        cell.configure(data: ApiManager.shared.filteredRooms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FindAudienceViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ApiManager.shared.filterRooms(pattern: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if GameParameters.game.opponent != nil {
            ApiManager.shared.putInQueueWithFriend()
        } else {
            ApiManager.shared.putInQueue()
        }
    }
}

extension FindAudienceViewController : ApiSearchRoomsLogic {
    func openWaitingScreen() {
        DispatchQueue.main.async {
            let waitingScreen = WaitingScreenViewController()
            self.navigationController?.setViewControllers([waitingScreen], animated: true)
        }
    }
    
    func moveToRegistration() {
        DispatchQueue.main.async {
        self.view.window?.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
        }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "We have a problems...", message: message, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}
