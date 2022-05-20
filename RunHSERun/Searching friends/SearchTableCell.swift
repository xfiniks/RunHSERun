import Foundation
import UIKit

protocol AddButtonLogic {
    func userAdded()
}

final class SearchTableCell : UITableViewCell {
    
    static let indentifier = "SearchTableCell"
    
    private lazy var id : Int = 0
    
    private lazy var nickname : UILabel = {
        let nickname = UILabel()
        nickname.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        nickname.textAlignment = .left
        nickname.textColor = .darkText
        nickname.translatesAutoresizingMaskIntoConstraints = false
        return nickname
    } ()
    
    private lazy var avatar : UIImageView = {
        let avatar = UIImageView()
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        avatar.backgroundColor = .white
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    } ()
    
    private lazy var statusButton : UIButton = {
        let statusButton = UIButton(type: .custom)
        statusButton.backgroundColor = UIColor(named: "forButtons")
        statusButton.contentHorizontalAlignment = .center
        statusButton.contentVerticalAlignment = .center
        statusButton.layer.cornerRadius = 20
        statusButton.layer.masksToBounds = false
        statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        statusButton.setTitle("Add", for: .normal)
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.addTarget(self, action: #selector(statusButtonClicked( _ :)), for: .touchUpInside)
        return statusButton
    } ()
    
    @objc private func statusButtonClicked(_ sender : UIButton) {
        ApiManager.shared.addFriendRequest(id: id)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.indentifier)
        ApiManager.shared.searchController = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: GameUser, id : Int) {
        avatar.image = data.avatar
        nickname.text = data.nickname
        self.id = id
    }
    
    private func configureUI() {
        contentView.addSubview(nickname)
        contentView.addSubview(statusButton)
        contentView.addSubview(avatar)
        
        NSLayoutConstraint.activate([
            
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            
            nickname.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            nickname.heightAnchor.constraint(equalToConstant: 40),
            nickname.trailingAnchor.constraint(equalTo: statusButton.leadingAnchor),
            nickname.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 15),
            
            statusButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            statusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusButton.widthAnchor.constraint(equalToConstant: 60),
            statusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}

extension SearchTableCell : AddButtonLogic {
    func userAdded() {
        statusButton.backgroundColor = .systemGray
        statusButton.isEnabled = false
    }
    
}
