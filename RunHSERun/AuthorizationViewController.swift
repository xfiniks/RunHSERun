import UIKit

class AuthorizationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.contents = background?.cgImage
        configureUI()
        setupAuthorizationTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private lazy var authorizationLabel : UILabel = {
        let authorizationLabel = UILabel()
        authorizationLabel.translatesAutoresizingMaskIntoConstraints = false
        authorizationLabel.text = "Authorization"
        authorizationLabel.textAlignment = .center
        authorizationLabel.font = authorizationLabel.font.withSize(30)
        authorizationLabel.textColor = .systemBlue
        return authorizationLabel
    } ()
    
    private lazy var inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.keyboardType =  .numberPad
        inputTextField.textAlignment = .center
        inputTextField.textColor = .black
        inputTextField.backgroundColor = .systemGray5
        inputTextField.layer.cornerRadius = 8
        inputTextField.placeholder = "Your code..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    }  ()
    
    private lazy var backToRegistrationButton: UIButton  = {
        let backToRegistrationButton = UIButton()
        backToRegistrationButton.setTitle("Change email", for: .normal)
        backToRegistrationButton.setTitleColor(.systemBlue, for: .normal)
        backToRegistrationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        backToRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
        backToRegistrationButton.addTarget(self, action: #selector(backToRegistrationButtonClicked), for: .touchUpInside)
        return backToRegistrationButton
    } ()
    
    @objc private func backToRegistrationButtonClicked() {
        let registration = RegistrationViewController()
        navigationController?.setViewControllers([registration], animated: true)
    }
    
    private lazy var newCodeButton : UIButton = {
        let newCodeButton = UIButton()
        newCodeButton.setTitle("Send new code", for: .normal)
        newCodeButton.isEnabled = false
        newCodeButton.setTitleColor(.systemBlue, for: .normal)
        newCodeButton.setTitleColor(.systemGray, for: .disabled)
        newCodeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        newCodeButton.addTarget(self, action: #selector(newCodeButtonClicked), for: .touchUpInside)
        newCodeButton.translatesAutoresizingMaskIntoConstraints = false
        return newCodeButton
    } ()
    
    
    @objc private func newCodeButtonClicked() {
        authorizationTimer?.invalidate()
        setupAuthorizationTimer()
        newCodeButton.isEnabled = false
        makeEmailRequest()
    }
    
    private func makeEmailRequest() {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "Email") ?? ""
        ApiManager.shared.login(email: email) { answer, email in
            DispatchQueue.main.async {
                switch answer {
                case .badInternet:
                    self.showAlert(message: "Bad internet connection")
                    
                case .correctEmail:
                   return
                case .badEmail:
                    self.showAlert(message: "Wrong email")
                default:
                    return
                }
            }
        }
    }
    
    private lazy var checkCodeButton : UIButton = {
        let checkCodeButton = UIButton(type: .custom)
        checkCodeButton.backgroundColor = .systemBlue
        checkCodeButton.contentHorizontalAlignment = .center
        checkCodeButton.contentVerticalAlignment = .center
        checkCodeButton.layer.cornerRadius = 20
        checkCodeButton.layer.masksToBounds = false
        checkCodeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        checkCodeButton.setTitle("Go", for: .normal)
        checkCodeButton.setTitleColor(.systemGray5, for: .selected)
        checkCodeButton.translatesAutoresizingMaskIntoConstraints = false
        checkCodeButton.addTarget(self, action: #selector(checkCodeButtonClicked), for: .touchUpInside)
        return checkCodeButton
    } ()
    
    
    @objc private func checkCodeButtonClicked() {
        makeRequest()
    }
    
    private func makeRequest() {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "Email")
        ApiManager.shared.checkCode(code: Int(inputTextField.text ?? "0") ?? 1, email: email!) { answer, user in
            DispatchQueue.main.async {
                switch answer {
                case .badInternet:
                    self.showAlert(message: "Bad internet connection")
                    
                case .userCreate:
                    let chooseNickname = ChooseNicknameViewController()
                    self.navigationController?.setViewControllers([chooseNickname], animated: true)
                
                case .userExist:
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
                    
                case .badCode:
                    self.inputTextField.textColor = .systemRed
                    
                case .badJSON:
                    self.showAlert(message: "Bad internet connection")
                    
                default:
                    return
                }
            }
        }
    }
    
    private lazy var checkEmailLabel : UILabel = {
        let checkEmailLabel = UILabel()
        checkEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        checkEmailLabel.textAlignment = .center
        checkEmailLabel.font = UIFont.boldSystemFont(ofSize: 22)
        checkEmailLabel.text = "Incorrect code"
        checkEmailLabel.textColor = .systemRed
        checkEmailLabel.isHidden = true
        return checkEmailLabel
    } ()
    
    private lazy var timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.font = timerLabel.font.withSize(17)
        timerLabel.textColor = .systemBlue
        return timerLabel
    } ()
    
    private var timeLeft = 60
        
    private var authorizationTimer : Timer?
    
    private func setupAuthorizationTimer() {
        authorizationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(authorizationTimerTick), userInfo: nil, repeats: true)
    }
    
    @objc private func authorizationTimerTick() {
        timeLeft -= 1
        updateUI()
    }
    
    private func updateUI() {
        if timeLeft == 0 {
            timerLabel.text = ""
            updateAuthorizationTimer()
            newCodeButton.isEnabled = true
        } else {
            timerLabel.text = "You can get a new code in \(timeLeft) seconds"
        }
    }
    
    private func updateAuthorizationTimer() {
        timeLeft = 60
        authorizationTimer?.invalidate()
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "We have a problems...", message: message, preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                self.present(alert, animated: true, completion: nil)
        }
    
    private func configureUI() {
            view.addSubview(authorizationLabel)
            view.addSubview(inputTextField)
            view.addSubview(timerLabel)
            view.addSubview(newCodeButton)
            view.addSubview(backToRegistrationButton)
            view.addSubview(checkCodeButton)
                
            NSLayoutConstraint.activate([
                authorizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                authorizationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                authorizationLabel.widthAnchor.constraint(equalToConstant: 250),
                authorizationLabel.heightAnchor.constraint(equalToConstant: 200),
                authorizationLabel.bottomAnchor.constraint(equalTo: inputTextField.centerYAnchor, constant: -35),
                
                inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
                inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                inputTextField.widthAnchor.constraint(equalToConstant: 200),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
                
                checkCodeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                checkCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 105),
                checkCodeButton.widthAnchor.constraint(equalToConstant: 40),
                checkCodeButton.heightAnchor.constraint(equalToConstant: 40),

                timerLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 40),
                timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                timerLabel.widthAnchor.constraint(equalToConstant: 300),
                timerLabel.heightAnchor.constraint(equalToConstant: 40),

                newCodeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50),
                newCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                newCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                newCodeButton.widthAnchor.constraint(equalToConstant: 100),
                newCodeButton.heightAnchor.constraint(equalToConstant: 20),
                
                backToRegistrationButton.topAnchor.constraint(equalTo:newCodeButton.bottomAnchor, constant: 25),
                backToRegistrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backToRegistrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backToRegistrationButton.widthAnchor.constraint(equalToConstant: 100),
                backToRegistrationButton.heightAnchor.constraint(equalToConstant: 20),
                
            ])
        }
}
