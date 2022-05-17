import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        resetDefaults()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let defaults = UserDefaults()
        if let _ = defaults.string(forKey: "Token") {
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
            window.rootViewController = bar
        } else {
            let nav = UINavigationController(rootViewController: RegistrationViewController())
            nav.isNavigationBarHidden = true
//            let nav = UINavigationController(rootViewController: ActivGameViewController())
            window.rootViewController = nav
        }
//        window.rootViewController = FindAudienceViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func firstScreen() {
            
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        defaults.dictionaryRepresentation().keys.forEach(defaults.removeObject(forKey:))
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

