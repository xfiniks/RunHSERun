import Foundation
import UIKit

class WaitingScreenViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
        setupAuthorizationTimer()
        nextText()
    }
    
    private lazy var backgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.backgroundColor = .white
        return view
    } ()
    
    private lazy var textLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = timerLabel.font.withSize(30)
        textLabel.textColor = .systemBlue
        textLabel.numberOfLines = 4
        return textLabel
    } ()
    
    private lazy var timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
        timerLabel.font = timerLabel.font.withSize(40)
        timerLabel.textColor = .systemBlue
        return timerLabel
    } ()
    
    private var timeLeft = 0
    
    private var gameTimer : Timer?
    
    private func setupAuthorizationTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
    }
    
    @objc private func gameTimerTick() {
        timeLeft += 1
        updateUI()
    }
    
    var textId : Int = 0
    
    let texts = ["Did you close the deadlines?", "Can you run faster than baby?", "I will rooting for your opponent...", "Turn around..."]
    
    private func nextText() {
        if textId == texts.count - 1 {
//            textLabel.animate(newText: texts[0], characterDelay: 0.05)
            textLabel.fadeTransition(0.4)
            textLabel.text = texts[0]
            textId = 0
        } else {
            textId += 1
            textLabel.fadeTransition(0.4)
            textLabel.text = texts[textId]
//            textLabel.animate(newText: texts[textId], characterDelay: 0.05)
        }
    }
    
    private func updateUI() {
        if (timeLeft != 0 && timeLeft % 15 == 0) {
            nextText()
        }
            var minutes = String(timeLeft / 60)
            var seconds = String(timeLeft % 60)
        if (timeLeft / 60 < 10) {
            minutes = "0\(minutes)"
        }
        if (timeLeft % 60 < 10) {
            seconds = "0\(seconds)"
        }
            timerLabel.text = "\(minutes):\(seconds)"
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
//        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        return exitButton
    } ()


    private lazy var gameLabel : UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textColor = .systemBlue
        gameLabel.textAlignment = .center
        gameLabel.font = gameLabel.font.withSize(30)
        gameLabel.text = "Waiting for the opponent"
        gameLabel.numberOfLines = 2
        return gameLabel
    } ()
    
    private func configureUI() {
        view.addSubview(timerLabel)
        view.addSubview(gameLabel)
        view.addSubview(backgroundView)
        view.addSubview(exitButton)
        backgroundView.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height / 2 - 30, width: 300, height: 230)
        backgroundView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([

            gameLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 30),
            gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameLabel.widthAnchor.constraint(equalToConstant: 250),
            gameLabel.heightAnchor.constraint(equalToConstant: 80),
            
            timerLabel.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 50),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 250),
            timerLabel.heightAnchor.constraint(equalToConstant: 100),
            
            textLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textLabel.widthAnchor.constraint(equalToConstant: 250),
            textLabel.heightAnchor.constraint(equalToConstant: 120),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            exitButton.widthAnchor.constraint(equalToConstant: 35),
            exitButton.heightAnchor.constraint(equalToConstant: 35),

        ])
    }
    
}

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    self.fadeTransition(characterDelay) // это анимация проявления
                }
            }
        }
    }
}

//extension UIView {
//    func fadeTransition(_ duration:CFTimeInterval) {
//        let animation = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        animation.type = CATransitionType.fade
//        animation.duration = duration
//        layer.add(animation, forKey: "kCATransitionFade")
//    }
//}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
