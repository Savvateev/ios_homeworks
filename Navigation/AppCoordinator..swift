import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let tabBarController = UITabBarController()
    private let window: UIWindow
    private var loginCoordinator: LoginCoordinator? // ← strong reference

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showLogin()
    }

    // MARK: - Login

    private func showLogin() {
        let loginCoord = LoginCoordinator()
        loginCoord.appCoordinator = self
        loginCoord.start()

        loginCoordinator = loginCoord // ← strong reference, не теряется

        guard let loginVC = loginCoord.loginViewController else { return }
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }

    func didLogin(user: User) {
        loginCoordinator = nil // ← освобождаем после логина
        setupTabs()

        if let profileCoord = childCoordinators.first(where: { $0 is ProfileCoordinator }) as? ProfileCoordinator {
            profileCoord.updateUser(user)
        }

        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.window.rootViewController = self.tabBarController
        })
    }

    func didTapLogo() {
        loginCoordinator = nil
        setupTabs()
        tabBarController.selectedIndex = 1

        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.window.rootViewController = self.tabBarController
        })
    }

    private func setupTabs() {
        let profileCoord = ProfileCoordinator()
        profileCoord.appCoordinator = self

        let feedCoord = FeedCoordinator()
        feedCoord.appCoordinator = self

        childCoordinators = [profileCoord, feedCoord]

        profileCoord.start()
        feedCoord.start()

        profileCoord.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 0
        )
        feedCoord.navigationController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "list.dash"),
            tag: 1
        )

        tabBarController.viewControllers = [
            profileCoord.navigationController,
            feedCoord.navigationController
        ]
    }

    func switchToFeed() {
        tabBarController.selectedIndex = 1
    }
}
