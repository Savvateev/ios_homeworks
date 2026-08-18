import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

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

    private lazy var loginButton = CustomButton(
        title: "Log In",
        titleColor: .white,
        bgImage: UIImage(named: "blue_pixel"),
        cornerRadius: 10
    ) { [weak self] in
        self?.loginButtonTouch()
    }

    var loginDelegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupLayout()
        setupLogoTap()
        setupTextFieldObservers()
        loginButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Layout

    private func setupLayout() {
        setupHierarchy()
        setupSeparator()
        setupConstraints()
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(inputStackView)

        inputStackView.addArrangedSubview(loginTextField)
        inputStackView.addArrangedSubview(passwordTextField)

        contentView.addSubview(loginButton)
    }

    private func setupSeparator() {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            separator.centerYAnchor.constraint(equalTo: inputStackView.centerYAnchor)
        ])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            inputStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            inputStackView.heightAnchor.constraint(equalToConstant: 100),

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

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }

    // MARK: - TextField Observers

    private func setupTextFieldObservers() {
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    @objc private func textFieldChanged() {
        let email = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
    }

    // MARK: - Actions

    private func loginButtonTouch() {
        guard let email = loginTextField.text, !email.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите email")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите пароль")
            return
        }

        guard let delegate = delegate else {
            showAlert(title: "Ошибка", message: "Сервис проверки недоступен")
            return
        }

        loginButton.isEnabled = false

        // Сначала пробуем войти
        delegate.checkCredentials(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true

                switch result {
                case .success:
                    self.navigateToProfile()

                case .failure(let error):
                    let nsError = error as NSError
                    // Пользователь не найден → регистрируем
                    if nsError.code == AuthErrorCode.userNotFound.rawValue {
                        self.signUpAndNavigate(email: email, password: password)
                    } else {
                        self.showAlert(title: "Ошибка входа", message: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func signUpAndNavigate(email: String, password: String) {
        guard let delegate = delegate else { return }

        delegate.signUp(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigateToProfile()
                case .failure(let error):
                    self.showAlert(title: "Ошибка регистрации", message: error.localizedDescription)
                }
            }
        }
    }

    private func navigateToProfile() {
        let profileVC = ProfileViewController()
        let user = User(
            login: loginTextField.text ?? "",
            fullName: loginTextField.text ?? "",
            avatar: UIImage(named: "test") ?? UIImage(),
            status: "Online"
        )
        profileVC.configure(with: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func setupLogoTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func logoTapped() {
        let feedVC = FeedViewController()
        navigationController?.pushViewController(feedVC, animated: true)
    }

    // MARK: - Keyboard Handling

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrameValue.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - UIImage Extension

extension UIImage {
    func withAlpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
