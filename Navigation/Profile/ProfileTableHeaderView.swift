import UIKit
import SnapKit // Не забудьте импортировать библиотеку

class ProfileHeaderView: UIView {
    
    // MARK: - UI Elements

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Cat")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Кошка"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "В ожидании..."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Статус"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()

//    private lazy var setStatusButton: UIButton = { 
//        let button = UIButton(type: .system)
//        button.setTitle("Новый статус", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(statusButtonTouch), for: .touchUpInside)
//        button.layer.cornerRadius = 4
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 4, height: 4)
//        button.layer.shadowRadius = 4
//        button.layer.shadowOpacity = 0.7
//        button.layer.masksToBounds = false
//        return button
//    }()
    
    private lazy var setStatusButton = CustomButton(
        title: "Новый статус",
        titleColor: .white,
        bgColor: .systemBlue
    ) { [weak self] in
        self?.statusButtonTapped()
    }
    
    // MARK: - Actions

//    @objc private func statusButtonTouch() {
//        print("Кнопка новый статус нажата")
//    }
    
    private func statusButtonTapped() {
        print("Кнопка новый статус нажата")
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("ошибка инициализации")
    }
    
    // MARK: - Private Methods

    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        // addSubview остается стандартным
        [avatarImageView, fullNameLabel, statusLabel, statusTextField, setStatusButton].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.size.equalTo(100) // ширина и высота сразу
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16) // отступ 16 с обеих сторон
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-16) // Важно для саморастягивающегося хедера
        }

        statusTextField.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.bottom.equalTo(setStatusButton.snp.top).offset(-10)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.bottom.equalTo(statusTextField.snp.top).offset(-10)
        }
    }
    
    func configure(with user: User) {
        avatarImageView.image = user.avatar
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
        statusTextField.text = user.status
    }
    
}
