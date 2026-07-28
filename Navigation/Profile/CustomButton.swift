//
//  CustomButton.swift
//  Navigation
//
//  Created by Pavel Savvateev on 28.07.2026.
//

import UIKit

class CustomButton: UIButton {
    
    // Замыкание, которое будет вызвано при нажатии
    private var action: (() -> Void)?
    
    // Инициализатор с основными параметрами
    init(title: String, titleColor: UIColor = .white, bgColor: UIColor = .systemBlue, action: (() -> Void)?) {
        self.action = action
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = 4
        titleLabel?.font = .systemFont(ofSize: 16)
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
    // Метод для обновления замыкания, если нужно изменить действие
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
}
