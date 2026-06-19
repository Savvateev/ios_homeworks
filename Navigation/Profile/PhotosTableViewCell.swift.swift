//
//  PhotosTableViewCell.swift.swift
//  Navigation
//
//  Created by Pavel Savvateev on 18.06.2026.
//
import UIKit

class PhotosTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.right")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let photosStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    
    private func setupViews() {
        setupHierarchy()
        setupPhotos()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(photosStackView)
    }
    
    private func setupPhotos() {
        // Создаем 4 фотографии (имена 1, 2, 3, 4)
        for i in 1...4 {
            let iv = UIImageView()
            iv.image = UIImage(named: "\(i)")
            iv.backgroundColor = .systemGray5
            iv.contentMode = .scaleAspectFill
            iv.layer.cornerRadius = 6
            iv.clipsToBounds = true
            photosStackView.addArrangedSubview(iv)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Ограничения для заголовка
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            // Ограничения для стрелки (центрирование по Y заголовка)
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            
            // Ограничения для галереи
            photosStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            photosStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photosStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            photosStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Пропорция 1:4 (высота ячейки зависит от ширины, чтобы фото были квадратными)
            photosStackView.heightAnchor.constraint(equalTo: photosStackView.widthAnchor, multiplier: 0.25, constant: -6)
        ])
    }
}
