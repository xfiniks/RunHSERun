import UIKit

class StartGameWithFriendViewController : UIViewController {
 
override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        ApiManager.shared.StartGameWithFriendViewController = self
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
        table.register(StartGameWithFriendTableCell.self, forCellReuseIdentifier: StartGameWithFriendTableCell.indentifier)
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
        friendslabel.font = friendslabel.font.withSize(35)
        friendslabel.text = "Friends"
        return friendslabel
    } ()
    
    private lazy var exitButton : UIButton = {
        let exitButton = UIButton(type: .custom)
        exitButton.backgroundColor = .white
        var image = UIImage(named: "exit")!.withRenderingMode(.alwaysOriginal)
        exitButton.setBackgroundImage(image, for: .normal)
        exitButton.contentHorizontalAlignment = .center
        exitButton.contentVerticalAlignment = .center
        exitButton.layer.cornerRadius = 15
        exitButton.layer.masksToBounds = false
        exitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        exitButton.setTitleColor(.systemGray5, for: .selected)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        return exitButton
    } ()
    
    @objc private func exitButtonClicked() {
        dismiss(animated: true)
    }
    
    private func configureUI() {
        
        view.addSubview(friendslabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            exitButton.widthAnchor.constraint(equalToConstant: 30),
            exitButton.heightAnchor.constraint(equalToConstant: 30),
            
            friendslabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 20),
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

extension StartGameWithFriendViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ApiManager.shared.filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StartGameWithFriendTableCell.indentifier, for: indexPath) as! StartGameWithFriendTableCell
        cell.configure(data: ApiManager.shared.filteredFriends[indexPath.row], id: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension StartGameWithFriendViewController : UISearchBarDelegate {
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

extension StartGameWithFriendViewController : ApiFriendsLogic {
    func moveToRegistration() {
        self.view.window?.rootViewController = RegistrationViewController()
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
