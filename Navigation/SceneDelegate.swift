import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appConfiguration: AppConfiguration = {
            let configurations: [AppConfiguration] = [
                .development("https://swapi.dev/api/planets/1"), // Татуин
                .staging("https://swapi.dev/api/starships/3"),
                .production("https://swapi.dev/api/planets/5")
            ]
            return configurations.randomElement()!
        }()
        
        NetworkService.request(for: appConfiguration)

        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        self.window = window
        self.appCoordinator = appCoordinator
        window.makeKeyAndVisible()
    }
}
