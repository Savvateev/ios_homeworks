import UIKit
import StorageService

class ProfileViewController: UIViewController {

    var isAdmin: Bool = false

    // MARK: - ViewModel

    private let viewModel = ProfileViewModel()

    // MARK: - Хранилище понравившихся постов (CoreData)        // NEW

    private let savedPostsStore = SavedPostsStore.shared       // NEW

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

    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Profile", "Feed", "Liked"])   // NEW: вкладка «Liked»
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    // NEW: заглушка для пустого списка «Liked»
    private lazy var noSavedLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока нет понравившихся постов.\\nДважды тапните по посту в «Feed», чтобы сохранить его сюда."
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // NEW: какая вкладка активна
    private var isShowingSaved: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        setupLayout()
        bindViewModel()
        if isAdmin {
            loadPosts()            // админ → лента с постами
        } else {
            setupEmptyMessage()   // обычный юзер → «здесь ничего нет»
        }
        updateEmptyState()          // NEW
    }

    // MARK: - Public Methods

    func configure(with user: User) {
        viewModel.setUser(user)
        //viewModel.setPosts(posts)
    }

    private func pushPhotosViewController() {
        let photosVC = PhotosViewController()
        // NEW: оборачиваем экран в собственный UINavigationController —
        // у него появляется независимый стек навигации (пригодится в следующих заданиях)
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
        view.addSubview(segmentControl)
        view.addSubview(noSavedLabel)        // NEW
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -10),

            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 32),

            // NEW: заглушка поверх области таблицы
            noSavedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSavedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            noSavedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noSavedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noSavedLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func bindViewModel() {
        viewModel.onProfileUpdated = { [weak self] in
            guard let self = self else { return }
            self.profileHeaderView.configure(with: self.viewModel)
            self.tableView.reloadData()
        }
    }

    private func setupUserInfo() {
        profileHeaderView.configure(with: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - NEW: лайк поста по двойному тапу

    private func savePost(_ post: Post) {
        if savedPostsStore.save(post) {
            tableView.reloadData()
            updateEmptyState()
            showAlert(title: "Понравилось ❤️", message: "Пост «\\(post.author)» сохранён во вкладке «Liked»")
        } else {
            showAlert(title: "Уже сохранено", message: "Этот пост уже есть во вкладке «Liked»")
        }
    }

    private func updateEmptyState() {
        let isEmpty = savedPostsStore.savedPosts().isEmpty
        noSavedLabel.isHidden = !(isShowingSaved && isEmpty)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @objc private func segmentChanged() {
        switch segmentControl.selectedSegmentIndex {
        case 0:                                  // Profile
            isShowingSaved = false
            tableView.reloadData()
            updateEmptyState()
        case 1:                                  // Feed
            let feedVC = FeedViewController()
            // NEW: та же обёртка в собственный UINavigationController
            let feedNavigationController = UINavigationController(rootViewController: feedVC)
            navigationController?.pushViewController(feedNavigationController, animated: true)
            segmentControl.selectedSegmentIndex = 0
        case 2:                                  // Liked — NEW
            isShowingSaved = true
            tableView.reloadData()
            updateEmptyState()
        default:
            break
        }
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
        case 2: return isShowingSaved ? savedPostsStore.savedPosts().count : viewModel.posts.count   // NEW
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            // NEW: во вкладке «Liked» показываем сохранённые посты тем же экраном
            let posts = isShowingSaved ? savedPostsStore.savedPosts() : viewModel.posts
            cell.configure(with: posts[indexPath.row])
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
