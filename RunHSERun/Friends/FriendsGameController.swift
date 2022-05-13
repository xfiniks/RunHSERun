import UIKit

protocol ApiFriendsLogic {
    func showAlert(message : String)
    func updateTable()
    func moveToRegistration()
}

class FriendsGameController : UIViewController {
 
override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        ApiManager.shared.friendsGameController = self
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiManager.shared.getfriends()
        ApiManager.shared.setFriends()
    }
    

    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FriendsListCell.self, forCellReuseIdentifier: FriendsListCell.indentifier)
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
    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 15
        searchBar.placeholder = "Enter a nickname..."
        searchBar.showsCancelButton = false
        return searchBar
    } ()
    
    private lazy var friendslabel : UILabel = {
        let friendslabel = UILabel()
        friendslabel.translatesAutoresizingMaskIntoConstraints = false
        friendslabel.textColor = .systemBlue
        friendslabel.textAlignment = .center
        friendslabel.font = friendslabel.font.withSize(30)
        friendslabel.text = "Friends"
        return friendslabel
    } ()
    
    private func configureUI() {
        
        view.addSubview(friendslabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            friendslabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            friendslabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friendslabel.widthAnchor.constraint(equalToConstant: 200),
            friendslabel.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: friendslabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension FriendsGameController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ApiManager.shared.filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListCell.indentifier, for: indexPath) as! FriendsListCell
        cell.configure(data: ApiManager.shared.filteredFriends[indexPath.row], id: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension FriendsGameController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var text : String
        if searchText == "" {
            text = ""
            ApiManager.shared.getfriends()
        } else {
            text = searchText
            ApiManager.shared.filterFriends(pattern: text)
        }

    }
}

extension FriendsGameController : ApiFriendsLogic {
    
    func moveToRegistration() {
        self.view.window?.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
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
