import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let loginVC = LoginViewController()
        
        let factory: LoginFactory = MyLoginFactory()
        loginVC.loginDelegate = factory.makeLoginInspector()
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        try? Auth.auth().signOut()
    }
}
