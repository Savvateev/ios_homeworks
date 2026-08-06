import UIKit

final class LoginCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var loginViewController: LoginViewController?

    var onLoginSucceeded: ((User) -> Void)?
    var onLogoTapped: (() -> Void)?

    func start() {
        let loginVC = LoginViewController()
        loginVC.loginCoordinator = self
        loginVC.loginDelegate = LoginInspector()
        loginViewController = loginVC
    }

    func loginSucceeded(user: User) {
        print(user)
        onLoginSucceeded?(user)
    }
}
