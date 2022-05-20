import Foundation
import UIKit

protocol DeleteButtonLogic {
    func userDeleted()
}

final class FriendsListCell : UITableViewCell {
    
    static let indentifier = "FrindsListCell"
    
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
        statusButton.backgroundColor = UIColor(named: "forDeleteButton")
        statusButton.contentHorizontalAlignment = .center
        statusButton.contentVerticalAlignment = .center
        statusButton.layer.cornerRadius = 20
        statusButton.layer.masksToBounds = false
        statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        statusButton.setTitle("Delete", for: .normal)
        statusButton.setTitleColor(.systemGray5, for: .selected)
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.addTarget(self, action: #selector(statusButtonClicked), for: .touchUpInside)
        return statusButton
    } ()
    
    @objc private func statusButtonClicked() {
        ApiManager.shared.deleteFriend(id: id)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.indentifier)
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
            statusButton.widthAnchor.constraint(equalToConstant: 90),
            statusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension FriendsListCell : DeleteButtonLogic {
    func userDeleted() {
        statusButton.backgroundColor = .systemGray
        statusButton.isEnabled = false
    }
    
}
