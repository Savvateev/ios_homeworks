import UIKit

final class LoginCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var loginViewController: LoginViewController?
    weak var appCoordinator: AppCoordinator?

    func start() {
        let loginVC = LoginViewController()
        loginVC.loginCoordinator = self
        loginVC.loginDelegate = LoginInspector()
        loginViewController = loginVC
    }

    func loginSucceeded(user: User) {
        print("✅ loginSucceeded called, appCoordinator is \(appCoordinator != nil ? "set" : "nil")") // ← для отладки
        appCoordinator?.didLogin(user: user)
    }
}
