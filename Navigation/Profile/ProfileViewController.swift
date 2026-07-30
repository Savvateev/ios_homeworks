import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = ProfileViewModel()
    
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
        let control = UISegmentedControl(items: ["Profile", "Feed"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false // ← добавить
        return control
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile" // ← добавить title для navbar
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged) // ← добавить addTarget
        setupLayout()
        bindViewModel()
        setupUserInfo()
    }
    
    // MARK: - Public Methods
    
    func configure(with user: User) {
        viewModel.setUser(user)
        viewModel.setPosts(posts)
    }
    
    private func pushPhotosViewController() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    // MARK: - Private Properties
    
    private let posts: [Post] = [
        Post(author: "LeoTolstoy", description: "пишу новый роман", image: "leotolstoy", likes: 10, views: 100),
        Post(author: "Medinsky", description: "переписываю историю", image: "medinsky", likes: 0, views: 1000),
        Post(author: "Selhoznadzor", description: "запрещаю армянскую форель", image: "rshn", likes: 5, views: 120),
        Post(author: "Roskomnadzor", description: "блокирую интернет", image: "rkn", likes: 1, views: 10000)
    ]
    
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
            segmentControl.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onProfileUpdated = { [weak self] in
            self?.profileHeaderView.configure(with: self!.viewModel)
            self?.tableView.reloadData()
        }
        
        viewModel.onStatusChanged = { [weak self] status in
            self?.profileHeaderView.configure(with: self!.viewModel)
        }
    }
    
    private func setupUserInfo() {
        profileHeaderView.configure(with: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func segmentChanged() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
        case 1:
            let feedVC = FeedViewController()
            navigationController?.pushViewController(feedVC, animated: true)
            segmentControl.selectedSegmentIndex = 0
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
