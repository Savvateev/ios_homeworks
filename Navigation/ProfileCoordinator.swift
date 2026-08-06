//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Pavel Savvateev on 06.08.2026.
//
import UIKit

final class ProfileCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var appCoordinator: AppCoordinator?
    
    init() {
        navigationController = UINavigationController()
    }
    
    func start() {
        let profileVC = ProfileViewController()
        profileVC.coordinator = self
        navigationController.setViewControllers([profileVC], animated: false)
    }
    
    func updateUser(_ user: User) {
        guard let profileVC = navigationController.viewControllers.first as? ProfileViewController else { return }
        profileVC.configure(with: user)
    }
    
    func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController.pushViewController(photosVC, animated: true)
    }
    
    func switchToFeed() {
        appCoordinator?.switchToFeed()
    }
}
