import UIKit

class LoginViewController: UIViewController {
    
    
    // обработка клавиатуры
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Не забывайте удалять наблюдатели, чтобы избежать утечек памяти
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // 1. Получаем размер клавиатуры из userInfo
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        // 2. Создаем отступ (учитываем, что часть экрана может быть скрыта TabBar'ом)
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        // 3. Применяем отступы для ScrollView
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // 1. Сбрасываем отступы при скрытии клавиатуры
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }



    // UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "VKLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Контейнер для полей
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .systemGray6
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginTextField: UITextField = createTextField(placeholder: "Email or phone")
    private lazy var passwordTextField: UITextField = {
        let tf = createTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        
        // Настройка фона через изображение
        if let pixelImage = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(pixelImage, for: .normal)
            button.setBackgroundImage(pixelImage.withAlpha(0.8), for: .highlighted)
            button.setBackgroundImage(pixelImage.withAlpha(0.8), for: .selected)
        }
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc private func loginButtonTouch() {
        //print("Кнопка login нажата")
        setupProfileLayout()
    }
    
    private func setupProfileLayout() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
        print("Кнопка login нажата")
    }
    
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupLayout()
    }

    // Setup
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(inputStackView)
        inputStackView.addArrangedSubview(loginTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        
        // Разделительная линия между полями
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addSubview(separator)
        
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // определяет размер прокрутки
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // InputStackView
            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            inputStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            inputStackView.heightAnchor.constraint(equalToConstant: 100),
            
            // Separator
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            separator.centerYAnchor.constraint(equalTo: inputStackView.centerYAnchor),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor(named: "accentColor")
        textField.autocapitalizationType = .none
        
        // Отступ текста слева
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
}

// настройка Alpha у UIImage
extension UIImage {
    func withAlpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
