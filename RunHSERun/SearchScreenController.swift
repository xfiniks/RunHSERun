import Foundation
import UIKit

class SearchScreenController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        filteredUsers = gameUsers
        configureUI()
    }
        
    let gameUsers : [GameUser] = [GameUser(nickname: "aaaaaaaaaaaaaaa", avatar: UIImage(named: "logo")!), GameUser(nickname: "bbbb", avatar: UIImage(named: "logo")!), GameUser(nickname: "ccccc", avatar: UIImage(named: "logo")!), GameUser(nickname: "ddddd", avatar: UIImage(named: "logo")!)]
    
    var filteredUsers = [GameUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var searchBarIsEmpty : Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
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
//        let image = UIImage(named: "background")
//        let imageView = UIImageView(image: image)
//        table.backgroundView = imageView
        table.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.indentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.sectionHeaderTopPadding = .zero
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.indentifier, for: indexPath) as! SearchTableCell
        cell.configure(data: filteredUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
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

extension SearchScreenController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = gameUsers.filter({ (user : GameUser) -> Bool in
            return user.nickname.lowercased().contains(searchText.lowercased())
        })
    }
}
