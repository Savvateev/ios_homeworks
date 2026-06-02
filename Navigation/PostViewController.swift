import UIKit

class PostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        title = posts[0].description
        setupBarButton()
    }
    
    private func setupBarButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showInfo))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func showInfo() {
        let infoVC = InfoViewController()
        present(infoVC, animated: true)
    }
}
