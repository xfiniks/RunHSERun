import UIKit

class FriendsGameController : UIViewController, UITableViewDelegate{
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
    }
    
    private lazy var friendslabel : UILabel = {
        let friendslabel = UILabel()
        friendslabel.translatesAutoresizingMaskIntoConstraints = false
        friendslabel.textColor = .systemBlue
        friendslabel.textAlignment = .center
        friendslabel.font = friendslabel.font.withSize(30)
        friendslabel.text = "Friends"
        return friendslabel
    } ()
    
//    private lazy var tableView : UITableView = {
//        let tableView = UITableView()
//        tableView.dataSource = self
//        tableView.delegate = self
//        return tableView
//    } ()
    
    private func configureUI() {
        view.addSubview(friendslabel)
        NSLayoutConstraint.activate([
            friendslabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            friendslabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friendslabel.widthAnchor.constraint(equalToConstant: 200),
            friendslabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
