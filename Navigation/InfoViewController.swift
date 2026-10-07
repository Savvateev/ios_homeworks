import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupAlertButton()
    }

    private func setupAlertButton() {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString("info.button", comment: "Show alert button title"),
            for: .normal
        )
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func showAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("info.alert.title", comment: "Alert title"),
            message: NSLocalizedString("info.alert.message", comment: "Alert message"),
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: NSLocalizedString("info.alert.yes", comment: "Confirmation action"),
            style: .default
        ) { _ in
            print("Нажато Да")
        }


        let cancelAction = UIAlertAction(
            title: NSLocalizedString("info.alert.no", comment: "Cancel action"),
            style: .cancel
        ) { _ in
            print("Нажато Нет")
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
