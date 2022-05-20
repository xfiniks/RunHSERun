import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private lazy var backgroundView : UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 20
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    } ()
    
    private lazy var titleImage: UIImageView = {
        let titleImage = UIImageView()
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.image =  UIImage(named: "logo")
        titleImage.contentMode = .scaleAspectFit
        return titleImage
    }()
    
    private lazy var registrationLabel: UILabel = {
        let inputLabel = UILabel()
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.text = "Registration"
        inputLabel.textAlignment = .center
        inputLabel.font = inputLabel.font.withSize(30)
        inputLabel.textColor = .systemBlue
        return inputLabel
    }()
    
    private lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.keyboardType = .emailAddress
        inputTextField.textAlignment = .center
        inputTextField.textColor = .black
        inputTextField.backgroundColor = .systemGray5
        inputTextField.layer.cornerRadius = 8
        inputTextField.placeholder = "swag@edu.hse.ru"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    } ()
    
    
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
        checkCodeButton.addTarget(self, action: #selector(inputButtonClicked), for: .touchUpInside)
        return checkCodeButton
    } ()
    
    private lazy var inputButton: UIButton  = {
        let inputButton = UIButton()
        inputButton.setTitle("Register", for: .normal)
        inputButton.setTitleColor(.systemBlue, for: .normal)
        inputButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        inputButton.translatesAutoresizingMaskIntoConstraints = false
        return inputButton
    } ()
    
    @objc private func inputButtonClicked() {
        makeEmailRequest()
    }
    
    @objc private func inputButtonTouched() {
        checkCodeButton.backgroundColor = .systemGray
    }
    
    private func makeEmailRequest() {
        ApiManager.shared.login(email: inputTextField.text ?? "") { answer, email in
            DispatchQueue.main.async {
                switch answer {
                case .badInternet:
                    self.showAlert(message: "Bad internet connection")
                    
                case .correctEmail:
                    let authorization = AuthorizationViewController()
                    let nav = UINavigationController(rootViewController: AuthorizationViewController())
                    nav.isNavigationBarHidden = true
                    self.view.window?.rootViewController = nav
                    self.navigationController?.setViewControllers([authorization], animated: true)
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: "Email")
                    
                case .badEmail:
                    self.showAlert(message: "Wrong email")
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
            view.addSubview(titleImage)
            view.addSubview(registrationLabel)
            view.addSubview(inputTextField)
            view.addSubview(checkCodeButton)
            NSLayoutConstraint.activate([
                titleImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                titleImage.widthAnchor.constraint(equalToConstant: 200),
                titleImage.heightAnchor.constraint(equalToConstant: 200),
                
                registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                registrationLabel.bottomAnchor.constraint(equalTo: inputTextField.centerYAnchor, constant: -35),
                registrationLabel.widthAnchor.constraint(equalToConstant: 200),
                registrationLabel.heightAnchor.constraint(equalToConstant: 100),
                
                inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
                inputTextField.widthAnchor.constraint(equalToConstant: 200),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
                inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                checkCodeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                checkCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 105),
                checkCodeButton.widthAnchor.constraint(equalToConstant: 40),
                checkCodeButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

}

