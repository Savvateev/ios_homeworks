import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupAlertButton()
    }
    
    private func setupAlertButton() {
        let button = UIButton(type: .system)
        button.setTitle("Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Продолжить?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Да", style: .default) { _ in
            print("Нажато Да")
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            print("Нажато Нет")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
