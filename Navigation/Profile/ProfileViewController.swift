import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let profileHeaderView: ProfileHeaderView = {
        let header = ProfileHeaderView()
        header.backgroundColor = .systemGray6
        return header
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрация
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        
        return tableView
    }()
    
    private let posts: [Post] = [
        Post(author: "LeoTolstoy", description: "пишу новый роман", image: "leotolstoy", likes: 10, views: 100 ),
        Post(author: "Medinsky", description: "переписываю историю", image: "medinsky", likes: 0, views: 1000 ),
        Post(author: "Selhoznadzor", description: "запрещаю армянскую форель", image: "rshn", likes: 5, views: 120 ),
        Post(author: "Roskomnadzor", description: "блокирую интернет", image: "rkn", likes: 1, views: 10000 )
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func pushPhotosViewController() {
        let photosVC = PhotosViewController()
        
        // Выполняем переход с помощью push
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
#if DEBUG
view.backgroundColor = .systemYellow
#else
view.backgroundColor = .systemBackground
#endif
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 0: Profile, 1: Photos, 2: Posts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 0            // Только хедер
        case 1: return 1            // Одна ячейка PhotosTableViewCell
        case 2: return posts.count  // Список постов
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            // Секция с фотографиями
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            // Секция с постами
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            cell.configure(with: posts[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Хедер отображаем только в самой первой секции
        return section == 0 ? profileHeaderView : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 220 : 0
    }
    
    // Убираем стандартные отступы между секциями для красоты
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Снимаем выделение
            tableView.deselectRow(at: indexPath, animated: true)
            
            // Если нажата секция с фотографиями
            if indexPath.section == 1 {
                pushPhotosViewController()
            }
        }
}
