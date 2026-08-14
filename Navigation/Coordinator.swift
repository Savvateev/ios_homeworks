//
//  Coordinator.swift
//  Navigation
//
//  Created by Pavel Savvateev on 06.08.2026.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
