import Foundation
import UIKit

protocol StartButtonLogic {
    func startGame()
}

final class StartGameWithFriendTableCell : UITableViewCell {
    
    static let indentifier = "StartGameWithFriendTableCell"
    
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
    
    private lazy var startButton : UIButton = {
        let startButton = UIButton(type: .custom)
        startButton.backgroundColor = .systemBlue
        startButton.contentHorizontalAlignment = .center
        startButton.contentVerticalAlignment = .center
        startButton.layer.cornerRadius = 20
        startButton.layer.masksToBounds = false
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.setTitle("Run", for: .normal)
        startButton.setTitleColor(.systemGray5, for: .selected)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(statusButtonClicked), for: .touchUpInside)
        return startButton
    } ()
    
    @objc private func statusButtonClicked() {
        
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
        contentView.addSubview(startButton)
        contentView.addSubview(avatar)
        
        NSLayoutConstraint.activate([
            
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            
            nickname.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
//            nickname.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 75),
            nickname.heightAnchor.constraint(equalToConstant: 40),
//            nickname.widthAnchor.constraint(equalToConstant: 150),
            nickname.trailingAnchor.constraint(equalTo: startButton.leadingAnchor),
            nickname.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 15),
            
            startButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 90),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension StartGameWithFriendTableCell : StartButtonLogic {
    func startGame() {
        
    }
    
}
