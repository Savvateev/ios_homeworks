//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Pavel Savvateev on 29.04.2026.
//

import UIKit

class ProfileHeaderView: UIView {

    // Фон
    private let headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.image = UIImage(named: "Cat")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Кошка"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Спит"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Статус", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        
        // Тень
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        // сабвью
        addSubview(headerBackgroundView)
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        
        // Обработка
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) error")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. Получаем отступ safeArea
        let topPadding = self.safeAreaInsets.top
        let screenWidth = self.bounds.width
        
        // 2. Аватарка
        avatarImageView.frame = CGRect(x: 16, y: topPadding + 16, width: 120, height: 120)
        
        // 3. Имя
        fullNameLabel.sizeToFit() // Рассчитываем размер текста
        fullNameLabel.frame = CGRect(
            x: (screenWidth - fullNameLabel.frame.width) / 2,
            y: topPadding + 27,
            width: fullNameLabel.frame.width,
            height: fullNameLabel.frame.height
        )
        
        // 4. Кнопка
        let buttonWidth = screenWidth - 32
        setStatusButton.frame = CGRect(
            x: 16,
            y: avatarImageView.frame.maxY + 16,
            width: buttonWidth,
            height: 50
        )
        
        // 5. Статус
        statusLabel.sizeToFit()
        statusLabel.frame = CGRect(
            x: (screenWidth - statusLabel.frame.width) / 2,
            y: setStatusButton.frame.minY - 34 - statusLabel.frame.height,
            width: statusLabel.frame.width,
            height: statusLabel.frame.height
        )
        
        // 6. Серый фон
        headerBackgroundView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: setStatusButton.frame.maxY + 16
        )
    }

    @objc func buttonPressed() {
        print("Текущий статус: \(statusLabel.text ?? "")")
    }
}
