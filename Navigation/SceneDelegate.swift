import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Создаем контроллеры
        let feedVC = FeedViewController()
        //let profileVC = ProfileViewController()
        let loginVC = LoginViewController()
        
        // Создаем навигационные контроллеры
        let feedNavVC = UINavigationController(rootViewController: feedVC)
        //let profileNavVC = UINavigationController(rootViewController: profileVC)
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        
        // Настройка TabBar
        feedNavVC.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 0)
        //profileNavVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 1)
        loginNavVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 1)
        
        // Создаем TabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [feedNavVC, loginNavVC]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
