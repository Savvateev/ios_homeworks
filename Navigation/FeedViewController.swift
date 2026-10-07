import UIKit

class FeedViewController: UIViewController {

    var isAdmin: Bool = false

    // MARK: - UI Elements

    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString(
            "feed.word.placeholder",
            comment: "Word input placeholder"
        )
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var checkGuessButton = CustomButton(
        title: NSLocalizedString(
            "feed.check.button",
            comment: "Check button title"
        ),
        titleColor: .white,
        bgColor: .systemBlue
    ) { [weak self] in
        self?.checkGuess()
    }

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "feed.result.waiting",
            comment: "Waiting for input message"
        )
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private Properties

    private let viewModel = FeedViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        if isAdmin {
            navigationItem.title = NSLocalizedString(
                "feed.title",
                comment: "Feed screen title"
            )
            setupAdminFeed()
        } else {
            navigationItem.title = NSLocalizedString(
                "feed.empty.title",
                comment: "Empty feed screen title"
            )
            setupEmptyFeed()
        }
    }

    private func setupEmptyFeed() {
        let emptyLabel = UILabel()
        emptyLabel.text = NSLocalizedString(
            "feed.empty.message",
            comment: "Empty feed message"
        )
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .systemGray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 200
            ),
            emptyLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            emptyLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
        ])

        emptyLabel.heightAnchor.constraint(equalToConstant: 30)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Private Methods

    private func setupAdminFeed() {
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
            guessTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 100
            ),
            guessTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            guessTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            guessTextField.heightAnchor.constraint(equalToConstant: 44),

            checkGuessButton.topAnchor.constraint(
                equalTo: guessTextField.bottomAnchor,
                constant: 16
            ),
            checkGuessButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            checkGuessButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),

            resultLabel.topAnchor.constraint(
                equalTo: checkGuessButton.bottomAnchor,
                constant: 24
            ),
            resultLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            resultLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            resultLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func checkGuess() {
        viewModel.check(word: guessTextField.text ?? "")

        switch viewModel.state {
        case .waiting, .checking:
            break

        case .checked(result: true):
            resultLabel.text = NSLocalizedString(
                "feed.result.correct",
                comment: "Correct answer message"
            )
            resultLabel.textColor = .systemGreen

        case .checked(result: false):
            resultLabel.text = NSLocalizedString(
                "feed.result.wrong",
                comment: "Incorrect answer message"
            )
            resultLabel.textColor = .systemRed

        case .error(error: .emptyText):
            resultLabel.text = NSLocalizedString(
                "feed.result.enter_word",
                comment: "Message shown when no word was entered"
            )
            resultLabel.textColor = .orange

        case .error(error: .invalidText):
            resultLabel.text = NSLocalizedString(
                "feed.result.wrong",
                comment: "Message shown for invalid input"
            )
            resultLabel.textColor = .systemRed
        }
    }

}
