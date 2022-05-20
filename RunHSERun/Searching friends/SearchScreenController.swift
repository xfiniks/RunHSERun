import Foundation
import UIKit

protocol ApiSearchFriendsLogic {
    func moveToRegistration()
    func updateTable()
    func showAlert(message : String)
}

class SearchScreenController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ApiManager.shared.searchScreenController = self
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
        WebSocketManager.shared.add(observer: self)
        WebSocketManager.shared.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        WebSocketManager.shared.remove(observer: self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiManager.shared.getUsersByPatternRequest(pattern: "")
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
        searchBar.placeholder = "Enter a nickname..."
        searchBar.showsCancelButton = false
        return searchBar
    } ()
    
    
    private lazy var searchlabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .cyan
        label.textAlignment = .center
        label.text = "Find friends"
        label.font = label.font.withSize(30)
        label.textColor = .systemBlue
        return label
    } ()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.indentifier)
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
            searchlabel.widthAnchor.constraint(equalToConstant: 200),
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

extension SearchScreenController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ApiManager.shared.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.indentifier, for: indexPath) as! SearchTableCell
        
        cell.configure(data: ApiManager.shared.filteredUsers[indexPath.row], id : indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension SearchScreenController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ApiManager.shared.getUsersByPatternRequest(pattern: searchText)
    }
}

extension SearchScreenController : ApiSearchFriendsLogic {
    
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

extension SearchScreenController : SocketObservable {
    func didConnect() {
        
    }
    
    func didDisconnect() {
        
    }
    
    func handleError(_ error: String) {
        
    }
    
    
}
