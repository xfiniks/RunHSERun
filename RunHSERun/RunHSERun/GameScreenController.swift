import UIKit

protocol userSettingsLogic {
    func changeNickname(nickname : String)
    func changeAvatar(id : Int)
    func showAlert(message: String)
}

class GameScreenController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        ApiManager.shared.gameScreenViewController = self
        configureUI()
    }
        
    private lazy var nicknameLabel : UILabel = {
        let nicknameLabel = UILabel()
        let defaults = UserDefaults()
        let nickname = defaults.string(forKey: "Nickname")
        nicknameLabel.font = nicknameLabel.font.withSize(30)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.textColor = .systemBlue
        nicknameLabel.textAlignment = .center
        nicknameLabel.text = nickname
        return nicknameLabel
    } ()
    
    private lazy var avatar : UIImageView = {
        let avatar = UIImageView()
        let defaults = UserDefaults()
        let avatarImage = defaults.integer(forKey: "ImageId")
        avatar.image = UIImage(named: "avatar\(avatarImage)")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 85
        avatar.clipsToBounds = true
        avatar.backgroundColor = .white
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    } ()
    
    private lazy var startGameButton : UIButton = {
        let startGameButton = UIButton(type: .custom)
        startGameButton.backgroundColor = .systemBlue
        startGameButton.contentHorizontalAlignment = .center
        startGameButton.contentVerticalAlignment = .center
        startGameButton.layer.cornerRadius = 20
        startGameButton.layer.masksToBounds = false
        startGameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startGameButton.setTitle("Start game", for: .normal)
        startGameButton.setTitleColor(.systemGray5, for: .selected)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.addTarget(self, action: #selector(startGameButtonClicked), for: .touchUpInside)
        return startGameButton
    } ()
    
    @objc private func startGameButtonClicked() {
        
    }
    
    private lazy var settingsButton : UIButton = {
        let settingsButton = UIButton(type: .custom)
        settingsButton.backgroundColor = .white
        settingsButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        settingsButton.contentHorizontalAlignment = .center
        settingsButton.contentVerticalAlignment = .center
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.masksToBounds = false
        settingsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.systemGray5, for: .selected)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        return settingsButton
    } ()
    
    @objc private func settingsButtonClicked() {
        present(SettingsViewController(), animated: true)
    }
    
    private lazy var startGameWithFriendButton : UIButton = {
        let startGameWithFriendButton = UIButton(type: .custom)
        startGameWithFriendButton.backgroundColor = .systemBlue
        startGameWithFriendButton.contentHorizontalAlignment = .center
        startGameWithFriendButton.contentVerticalAlignment = .center
        startGameWithFriendButton.layer.cornerRadius = 20
        startGameWithFriendButton.layer.masksToBounds = false
        startGameWithFriendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startGameWithFriendButton.setTitle("Start game with friend", for: .normal)
//        startGameWithFriendButton.setTitleColor(.systemGray5, for: .selected)
        startGameWithFriendButton.translatesAutoresizingMaskIntoConstraints = false
        startGameWithFriendButton.addTarget(self, action: #selector(startGameWithFriendButtonClicked), for: .touchUpInside)
        return startGameWithFriendButton
    } ()
    
    @objc private func startGameWithFriendButtonClicked() {
        
    }
    
    private func configureUI() {
        view.addSubview(avatar)
        view.addSubview(nicknameLabel)
        view.addSubview(startGameButton)
        view.addSubview(settingsButton)
        view.addSubview(startGameWithFriendButton)
        
        NSLayoutConstraint.activate([
        
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalToConstant: 40),
            
            avatar.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 80),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 200),
            avatar.heightAnchor.constraint(equalToConstant: 200),
            
            nicknameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 15),
            nicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 40),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 200),
            
            startGameButton.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 80),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameButton.widthAnchor.constraint(equalToConstant: 250),
            startGameButton.heightAnchor.constraint(equalToConstant: 60),
            
            startGameWithFriendButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: 20),
            startGameWithFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameWithFriendButton.widthAnchor.constraint(equalToConstant: 250),
            startGameWithFriendButton.heightAnchor.constraint(equalToConstant: 60)
    
        ])
    }
    
}

extension GameScreenController : userSettingsLogic {
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "We have a problems...", message: message, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
    }
    
    func changeNickname(nickname : String) {
        nicknameLabel.text = nickname
    }
    
    func changeAvatar(id : Int) {
        avatar.image = UIImage(named: "avatar\(id)")
    }

}