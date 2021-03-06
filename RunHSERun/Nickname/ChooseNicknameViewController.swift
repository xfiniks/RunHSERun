import UIKit

class ChooseNicknameViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.contents = background?.cgImage
        configureUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private lazy var nicknameFormatLabel : UILabel = {
        let nicknameFormatLabel = UILabel()
        nicknameFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameFormatLabel.numberOfLines = 4
        nicknameFormatLabel.text = """
            Nickname must be no more than 15 characters and consist of letters, numbers and the _ symbol
        """
        nicknameFormatLabel.textAlignment = .center
        nicknameFormatLabel.font = nicknameFormatLabel.font.withSize(15)
        nicknameFormatLabel.textColor = .systemRed
        nicknameFormatLabel.isHidden = true
        return nicknameFormatLabel
    } ()
    
    private lazy var chooseNicknameLabel: UILabel = {
        let chooseNicknameLabel = UILabel()
        chooseNicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseNicknameLabel.text = "Nickname"
        chooseNicknameLabel.textAlignment = .center
        chooseNicknameLabel.font = chooseNicknameLabel.font.withSize(30)
        chooseNicknameLabel.textColor = .systemBlue
        return chooseNicknameLabel
    }()
    
    private lazy var inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.keyboardType = .default
        inputTextField.textAlignment = .center
        inputTextField.textColor = .black
        inputTextField.backgroundColor = .systemGray5
        inputTextField.layer.cornerRadius = 8
        inputTextField.placeholder = "Sosnovskiy..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    }  ()
    
    
    private lazy var setNicknameButton : UIButton = {
        let setNicknameButton = UIButton(type: .custom)
        setNicknameButton.backgroundColor = .systemBlue
        setNicknameButton.contentHorizontalAlignment = .center
        setNicknameButton.contentVerticalAlignment = .center
        setNicknameButton.layer.cornerRadius = 20
        setNicknameButton.layer.masksToBounds = false
        setNicknameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setNicknameButton.setTitle("Run", for: .normal)
        setNicknameButton.translatesAutoresizingMaskIntoConstraints = false
        setNicknameButton.addTarget(self, action: #selector(setNicknameButtonClicked), for: .touchUpInside)
        return setNicknameButton
    } ()
    
    @objc private func setNicknameButtonClicked() {
        if let text = inputTextField.text, text == "" {
            showAlert(message: "Nickname cannot be empty")
        } else {
            makeRequest()
        }
    }
    
    private func makeRequest(){
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "Email") ?? ""
        ApiManager.shared.createUser(nickname: inputTextField.text ?? "", email: email) { answer, user in
            DispatchQueue.main.async {
                switch answer {
                case .badInternet:
                    self.showAlert(message: "Bad internet connection")
                    
                case .userAlreadyCreate:
                    self.showAlert(message: "Another user already register with your email")
                    let registration = RegistrationViewController()
                    self.navigationController?.setViewControllers([registration], animated: true)
                    self.navigationController?.isNavigationBarHidden = true
                
                case .userCreateSuccessfully:
                    if let userInfo = user {
                        let defaults = UserDefaults.standard
                        defaults.set(userInfo.token, forKey: "Token")
                        defaults.set(userInfo.user.email, forKey: "Email")
                        defaults.set(userInfo.user.id, forKey: "Id")
                        defaults.set(userInfo.user.nickname, forKey: "Nickname")
                        defaults.set(userInfo.user.image, forKey: "ImageId")
                        
                        let bar = UITabBarController()
                        bar.tabBar.unselectedItemTintColor = .systemGray
                        bar.tabBar.backgroundColor = .systemGray5
                        let viewControllers = [SearchScreenController(), GameScreenController(), FriendsGameController()]
                        bar.setViewControllers(viewControllers, animated: true)
                        let items = bar.tabBar.items!
                        let images = ["searchTabBarIcon", "gameTabBarIcon", "friendsTabBarIcon"]
                        let titles = ["Search", "Game", "Friends"]
                        for i in 0 ..< viewControllers.count {
                            items[i].image = UIImage(named: images[i])
                            items[i].title = titles[i]
                        }
                        
                        self.view.window?.rootViewController = bar
                    }
                    
                case .nicknameAlreadyExists:
                    self.showAlert(message: "Nickname Already Exists")
                    
                case .incorrectNickname:
                    self.nicknameFormatLabel.isHidden = false
                    
                default:
                    return
                }
            }
        }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "We have a problems...", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
        }
    
    private func configureUI() {
        view.addSubview(setNicknameButton)
        view.addSubview(chooseNicknameLabel)
        view.addSubview(inputTextField)
        view.addSubview(nicknameFormatLabel)
            
        NSLayoutConstraint.activate([
            
            chooseNicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chooseNicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chooseNicknameLabel.bottomAnchor.constraint(equalTo: inputTextField.centerYAnchor, constant: -35),
            chooseNicknameLabel.widthAnchor.constraint(equalToConstant: 250),
            chooseNicknameLabel.heightAnchor.constraint(equalToConstant: 200),
            
            inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35),
            inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            inputTextField.widthAnchor.constraint(equalToConstant: 200),
            inputTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setNicknameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            setNicknameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 105),
            setNicknameButton.widthAnchor.constraint(equalToConstant: 60),
            setNicknameButton.heightAnchor.constraint(equalToConstant: 40),
            
            nicknameFormatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameFormatLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 30),
            nicknameFormatLabel.widthAnchor.constraint(equalToConstant: 250),
            nicknameFormatLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
