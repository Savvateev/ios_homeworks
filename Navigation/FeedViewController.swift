import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите слово"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Проверить",
        titleColor: .white,
        bgColor: .systemBlue
    ) { [weak self] in
        self?.checkGuess()
    }
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Ожидание ввода..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    
    private let feedModel = FeedModel(secretWord: "password")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Feed"
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(guessTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            guessTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            guessTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            guessTextField.heightAnchor.constraint(equalToConstant: 44),
            
            checkGuessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 16),
            checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 24),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func checkGuess() {
        guard let text = guessTextField.text, !text.isEmpty else {
            resultLabel.text = "Введите слово!"
            resultLabel.textColor = .orange
            return
        }
        
        let isCorrect = feedModel.check(word: text)
        
        if isCorrect {
            resultLabel.text = "✅ Верно!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "❌ Неверно!"
            resultLabel.textColor = .systemRed
        }
    }
}
