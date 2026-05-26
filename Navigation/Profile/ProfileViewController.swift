//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Pavel Savvateev on 29.04.2026.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profileLoginView: LoginViewController = {
        let view = LoginViewController()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Кнопка", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Профиль"
        setupLoginLayout()
        //setupLayout()
    }

    private func setupLoginLayout() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func setupLayout() {

        view.addSubview(profileHeaderView)
        view.addSubview(bottomButton)

        NSLayoutConstraint.activate([
        
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),

            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
