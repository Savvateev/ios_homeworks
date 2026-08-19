import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Сильная ссылка, чтобы LoginInspector не деаллоцировался
    private var loginInspector: LoginInspector?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let loginVC = LoginViewController()
        
        let factory: LoginFactory = MyLoginFactory()
        loginInspector = factory.makeLoginInspector()
        loginVC.loginDelegate = loginInspector
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
