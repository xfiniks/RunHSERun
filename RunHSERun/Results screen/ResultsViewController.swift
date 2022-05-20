import Foundation
import UIKit

class ResultsViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GameParameters.game.gameResult == nil {
            gameLabel.text = "Waiting for results..."
        } else {
            gameLabel.text = GameParameters.game.gameResult
        }
        let time = GameParameters.game.gameTime
        var minutes = String((time ?? 0) / 60)
        var seconds = String((time ?? 0) % 60)
        if ((time ?? 0) / 60 < 10) {
            minutes = "0\(minutes)"
        }
        if ((time ?? 0) % 60 < 10) {
            seconds = "0\(seconds)"
        }
        timerLabel.text = "Your time is: \(minutes):\(seconds)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WebSocketManager.shared.remove(observer: self)
    }
    
    func setup() {
        WebSocketManager.shared.add(observer: self)
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
        textLabel.textColor = UIColor(named: "forResults")
        textLabel.numberOfLines = 4
        return textLabel
    } ()
    
    private lazy var timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.font = timerLabel.font.withSize(30)
        timerLabel.textColor = .systemBlue
        return timerLabel
    } ()
    
    
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
        DispatchQueue.main.async {
            GameParameters.game.opponent = nil
            GameParameters.game.audience = nil
            GameParameters.game.gameID = nil
            GameParameters.game.opponentsName = nil
            GameParameters.game.gameTime = nil
            GameParameters.game.gameResult = nil
            
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
    }


    private lazy var gameLabel : UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textColor = UIColor(named: "forResults")
        gameLabel.textAlignment = .center
        gameLabel.font = gameLabel.font.withSize(40)
        gameLabel.numberOfLines = 2
        return gameLabel
    } ()
    
    private func configureUI() {
        view.addSubview(gameLabel)
        view.addSubview(backgroundView)
        view.addSubview(exitButton)
        backgroundView.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height / 2 - 50, width: 300, height: 200)
        backgroundView.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([

            gameLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 60),
            gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameLabel.widthAnchor.constraint(equalToConstant: 300),
            gameLabel.heightAnchor.constraint(equalToConstant: 100),
            
            timerLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 250),
            timerLabel.heightAnchor.constraint(equalToConstant: 120),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            exitButton.widthAnchor.constraint(equalToConstant: 35),
            exitButton.heightAnchor.constraint(equalToConstant: 35),

        ])
    }
    
}

extension ResultsViewController : SocketObservable {
    func didConnect() {
        
    }
    
    func didDisconnect() {
        
    }
    
    func handleError(_ error: String) {
        
    }
    
    func logSignal(_ signal: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.gameLabel.text = GameParameters.game.gameResult
        }
    }
    
}
