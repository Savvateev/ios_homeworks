import UIKit
import StorageService

class ProfileViewController: UIViewController {

    var isAdmin: Bool = false

    // MARK: - ViewModel

    private let viewModel = ProfileViewModel()

    // MARK: - Хранилище понравившихся постов (Core Data)

    private let savedPostsStore = SavedPostsStore.shared

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

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        setupLayout()
        bindViewModel()
        if isAdmin {
            loadPosts()
        } else {
            setupEmptyMessage()
        }
    }

    // MARK: - Public Methods

    func configure(with user: User) {
        viewModel.setUser(user)
    }

    private func pushPhotosViewController() {
        let photosVC = PhotosViewController()
        let photosNavigationController = UINavigationController(rootViewController: photosVC)
        navigationController?.pushViewController(photosNavigationController, animated: true)
    }

    private func setupEmptyMessage() {
        let emptyLabel = UILabel()
        emptyLabel.text = "Здесь пока ничего нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .systemGray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func loadPosts() {
        let posts = [
            Post(author: "LeoTolstoy", description: "пишу новый роман", image: "leotolstoy", likes: 10, views: 100),
            Post(author: "Medinsky", description: "переписываю историю", image: "medinsky", likes: 0, views: 1000),
            Post(author: "Selhoznadzor", description: "запрещаю армянскую форель", image: "rshn", likes: 5, views: 120),
            Post(author: "Roskomnadzor", description: "блокирую интернет", image: "rkn", likes: 1, views: 10000)
        ]
        viewModel.setPosts(posts)
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func bindViewModel() {
        viewModel.onProfileUpdated = { [weak self] in
            guard let self = self else { return }
            self.profileHeaderView.configure(with: self.viewModel)
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Лайк поста по двойному тапу

    private func savePost(_ post: Post) {
        savedPostsStore.save(post) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(true):
                self.showAlert(
                    title: "Понравилось ❤️",
                    message: "Пост «\(post.author)» сохранён во вкладке Liked"
                )

            case .success(false):
                self.showAlert(
                    title: "Уже сохранено",
                    message: "Этот пост уже есть во вкладке Liked"
                )

            case .failure(let error):
                self.showError(error)
            }
        }
    }


    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        present(alert, animated: true)
    }



}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
        case 1: return 1
        case 2: return viewModel.posts.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            cell.configure(with: viewModel.posts[indexPath.row])
            cell.onDoubleTap = { [weak self] post in
                self?.savePost(post)
            }
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? profileHeaderView : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 220 : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 1 {
            pushPhotosViewController()
        }
    }
}
