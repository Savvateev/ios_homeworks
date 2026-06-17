//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Pavel Savvateev on 29.04.2026.
//

import UIKit

class ProfileHeaderView: UIView {
    
    //UI  элементы

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Cat")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // Уменьшим немного для высоты 220
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Кошка"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "В ожидании..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Статус"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // Отступ текста
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Новый статус", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(ProfileHeaderView.self, action: #selector(statusButtonTouch), for: .touchUpInside)
        button.layer.cornerRadius = 4
        // тень
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.layer.masksToBounds = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func statusButtonTouch() {
        print("Кнопка новый статус нажата")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("ошибка инициализации")
    }
    
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Аватарка
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            // Имя
            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            // Кнопка
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            // Статус
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: statusTextField.topAnchor, constant: -10),

            // Поле ввода статуса
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -10)
        ])
    }
}
