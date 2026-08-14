//
//  FeedCoordinator..swift
//  Navigation
//
//  Created by Pavel Savvateev on 06.08.2026.
//
import UIKit

final class FeedCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var appCoordinator: AppCoordinator?
    
    init() {
        navigationController = UINavigationController()
    }
    
    func start() {
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: false)
    }
}
