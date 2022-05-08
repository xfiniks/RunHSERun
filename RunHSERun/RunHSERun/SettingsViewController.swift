import Foundation
import UIKit

protocol SettingsLogic {
    func changeAvatar(id : Int)
    func showAlert(message: String)
    func showSuccessAlert(message: String)
}

class SettingsViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        ApiManager.shared.settingsViewController = self
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
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
        
    private lazy var accountSettingsLabel : UILabel = {
        let accountSettingsLabel = UILabel()
        accountSettingsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountSettingsLabel.textColor = .systemBlue
        accountSettingsLabel.textAlignment = .center
        accountSettingsLabel.font = accountSettingsLabel.font.withSize(30)
        accountSettingsLabel.text = "Account Settings"
        return accountSettingsLabel
    } ()
    
    private lazy var nicknameTextField : UITextField = {
        let nicknameTextField = UITextField()
        nicknameTextField.keyboardType = .default
        nicknameTextField.textAlignment = .center
        nicknameTextField.textColor = .black
        nicknameTextField.backgroundColor = .systemGray5
        nicknameTextField.layer.cornerRadius = 8
        nicknameTextField.placeholder = "Type new nickname..."
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nicknameTextField
    } ()
    
    private lazy var shuffleAvatarButton : UIButton = {
        let shuffleAvatarButton = UIButton(type: .custom)
        shuffleAvatarButton.backgroundColor = .systemBlue
        shuffleAvatarButton.contentHorizontalAlignment = .center
        shuffleAvatarButton.contentVerticalAlignment = .center
        shuffleAvatarButton.layer.cornerRadius = 20
        shuffleAvatarButton.layer.masksToBounds = false
        shuffleAvatarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        shuffleAvatarButton.setTitle("Shuffle avatar", for: .normal)
        shuffleAvatarButton.setTitleColor(.systemGray5, for: .selected)
        shuffleAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleAvatarButton.addTarget(self, action: #selector(shuffleAvatarButtonClicked), for: .touchUpInside)
        return shuffleAvatarButton
    } ()
    
    @objc private func shuffleAvatarButtonClicked() {
        ApiManager.shared.changeAvatar()
    }
    
    private lazy var setNicknameButton : UIButton = {
        let setNicknameButton = UIButton(type: .custom)
        setNicknameButton.backgroundColor = .systemBlue
        setNicknameButton.contentHorizontalAlignment = .center
        setNicknameButton.contentVerticalAlignment = .center
        setNicknameButton.layer.cornerRadius = 20
        setNicknameButton.layer.masksToBounds = false
        setNicknameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setNicknameButton.setTitle("Set", for: .normal)
        setNicknameButton.setTitleColor(.systemGray5, for: .selected)
        setNicknameButton.translatesAutoresizingMaskIntoConstraints = false
        setNicknameButton.addTarget(self, action: #selector(setNicknameButtonClicked), for: .touchUpInside)
        return setNicknameButton
    } ()
    
    @objc private func setNicknameButtonClicked() {
        ApiManager.shared.changeNickname(nickname: nicknameTextField.text ?? "")
    }
    
    private lazy var exitButton : UIButton = {
        let exitButton = UIButton(type: .custom)
        exitButton.backgroundColor = .white
        var image = UIImage(named: "exit")!.withRenderingMode(.alwaysOriginal)
        exitButton.setBackgroundImage(image, for: .normal)
        exitButton.contentHorizontalAlignment = .center
        exitButton.contentVerticalAlignment = .center
        exitButton.layer.cornerRadius = 20
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
        view.addSubview(accountSettingsLabel)
        view.addSubview(avatar)
        view.addSubview(nicknameTextField)
        view.addSubview(setNicknameButton)
        view.addSubview(shuffleAvatarButton)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            exitButton.widthAnchor.constraint(equalToConstant: 35),
            exitButton.heightAnchor.constraint(equalToConstant: 35),
            
            accountSettingsLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 45),
            accountSettingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountSettingsLabel.widthAnchor.constraint(equalToConstant: 250),
            accountSettingsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            avatar.topAnchor.constraint(equalTo: accountSettingsLabel.bottomAnchor, constant: 50),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 200),
            avatar.heightAnchor.constraint(equalToConstant: 200),
            
            nicknameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35),
            nicknameTextField.centerYAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 90),

            nicknameTextField.widthAnchor.constraint(equalToConstant: 200),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setNicknameButton.centerYAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 90),
            setNicknameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 105),
            setNicknameButton.widthAnchor.constraint(equalToConstant: 60),
            setNicknameButton.heightAnchor.constraint(equalToConstant: 40),
            
            shuffleAvatarButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 45),
            shuffleAvatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shuffleAvatarButton.widthAnchor.constraint(equalToConstant: 250),
            shuffleAvatarButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}

extension SettingsViewController : SettingsLogic {
   
    func showAlert(message: String) {
            let alert = UIAlertController(title: "We have a problems...", message: message, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(message: String) {
            let alert = UIAlertController(title: "Uhuuuu", message: message, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
    }
    
    func changeAvatar(id : Int) {
        avatar.image = UIImage(named: "avatar\(id)")
    }
}

