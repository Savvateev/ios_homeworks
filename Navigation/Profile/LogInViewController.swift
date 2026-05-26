//
//  LogInViewController.swift
//  Navigation
//
//  Created by Pavel Savvateev on 26.05.2026.
//
    
    import UIKit

    class LoginViewController: UIViewController {
        
        // MARK: - UI Elements
        
        private let logoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "VKLogo")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private lazy var loginTextField: UITextField = {
            let textField = createTextField(placeholder: "Email or phone")
            return textField
        }()
        
        private lazy var passwordTextField: UITextField = {
            let textField = createTextField(placeholder: "Password")
            textField.isSecureTextEntry = true
            return textField
        }()
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.spacing = 0 // Границы будут накладываться друг на друга
            stackView.layer.borderColor = UIColor.lightGray.cgColor
            stackView.layer.borderWidth = 0.5
            stackView.layer.cornerRadius = 10
            stackView.clipsToBounds = true
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let loginButton: UIButton = {
            let button = UIButton()
            button.setTitle("Log In", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17)
            if let pixelImage = UIImage(named: "blue_pixel") {
                button.setBackgroundImage(pixelImage, for: .normal)
            }
            
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // Настройка состояний alpha через замыкание или расширение (ниже упрощенно)
            return button
        }()

        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupViews()
            setupConstraints()
        }
        
        // MARK: - Setup
        
        private func setupViews() {
            view.addSubview(logoImageView)
            
            // Добавляем поля в стек
            containerStackView.addArrangedSubview(loginTextField)
            containerStackView.addArrangedSubview(passwordTextField)
            view.addSubview(containerStackView)
            
            // Разделительная линия между полями (так как borderWidth 0.5 у обоих создаст 1pt)
            let separator = UIView()
            separator.backgroundColor = .lightGray
            containerStackView.addSubview(separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: 0.5),
                separator.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
                separator.centerYAnchor.constraint(equalTo: containerStackView.centerYAnchor)
            ])
            
            view.addSubview(loginButton)
            setupButtonStates()
        }
        
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                // Logo: 120pt top, center X, 100x100 (размер обычно фиксируют для лого)
                logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.widthAnchor.constraint(equalToConstant: 100),
                logoImageView.heightAnchor.constraint(equalToConstant: 100),
                
                // Container (StackView): 120pt from Logo, 16pt margins, 100pt height (2x50)
                containerStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
                containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                containerStackView.heightAnchor.constraint(equalToConstant: 100),
                
                // Login Button: 16pt from container, 16pt margins, 50pt height
                loginButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 16),
                loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                loginButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func createTextField(placeholder: String) -> UITextField {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.backgroundColor = .systemGray6
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 16, weight: .regular)
            textField.tintColor = UIColor(named: "accentColor") // Используем ваш Color Set
            textField.autocapitalizationType = .none
            
            // Отступы текста внутри поля
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            return textField
        }
        
        private func setupButtonStates() {
            // Логика изменения прозрачности в зависимости от состояния
            loginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            // Чтобы реализовать изменение alpha при нажатии (highlighted),
            // в реальном проекте лучше переопределить свойство isHighlighted в подклассе UIButton.
        }
        
        @objc private func buttonAction() {
            // Действие при нажатии
        }
    }

