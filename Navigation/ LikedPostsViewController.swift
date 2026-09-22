import UIKit
import StorageService

final class LikedPostsViewController: UIViewController {

    // MARK: - Properties

    private let savedPostsStore = SavedPostsStore.shared

    private var displayedPosts: [Post] = []

    private var authorFilter: String?

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: "PostCell"
        )

        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Liked"

        setupNavigationBar()
        setupLayout()
        reloadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Обновляем список после перехода во вкладку.
        reloadPosts()
    }

    // MARK: - Navigation Bar

    private func setupNavigationBar() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )

        searchButton.accessibilityLabel = "Поиск по автору"

        let clearFilterButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(clearFilterButtonTapped)
        )

        clearFilterButton.accessibilityLabel = "Очистить фильтр"

        // На NavigationBar будут две кнопки:
        // поиск и очистка фильтра.
        navigationItem.rightBarButtonItems = [
            clearFilterButton,
            searchButton
        ]
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            emptyLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            emptyLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
    }

    // MARK: - Data

    private func reloadPosts() {
        if let authorFilter = authorFilter {
            displayedPosts = savedPostsStore.savedPosts(
                byAuthor: authorFilter
            )
        } else {
            displayedPosts = savedPostsStore.savedPosts()
        }

        updateEmptyState()
        tableView.reloadData()
    }

    private func updateEmptyState() {
        if displayedPosts.isEmpty {
            if authorFilter == nil {
                emptyLabel.text = "Нет понравившихся постов"
            } else {
                emptyLabel.text = "Посты указанного автора не найдены"
            }

            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    }

    // MARK: - Search

    @objc private func searchButtonTapped() {
        let alert = UIAlertController(
            title: "Поиск по автору",
            message: "Введите имя автора",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Например, LeoTolstoy"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }

        let applyAction = UIAlertAction(
            title: "Применить",
            style: .default
        ) { [weak self, weak alert] _ in

            guard let self = self else { return }

            let author = alert?.textFields?.first?.text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

            if author.isEmpty {
                self.authorFilter = nil
            } else {
                self.authorFilter = author
            }

            self.reloadPosts()
        }

        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )

        alert.addAction(applyAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    // MARK: - Очистка фильтра

    @objc private func clearFilterButtonTapped() {
        authorFilter = nil
        reloadPosts()
    }

    // MARK: - Error

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

extension LikedPostsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return displayedPosts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as! PostTableViewCell

        let post = displayedPosts[indexPath.row]

        cell.configure(with: post)

        // Двойной тап в сохранённых постах не нужен.
        cell.onDoubleTap = nil

        return cell
    }
}

// MARK: - UITableViewDelegate

extension LikedPostsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }

    // MARK: - Swipe Delete

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in

            guard let self = self else {
                completion(false)
                return
            }

            let post = self.displayedPosts[indexPath.row]

            self.savedPostsStore.delete(post) { [weak self] result in
                guard let self = self else {
                    completion(false)
                    return
                }

                switch result {
                case .success:
                    self.reloadPosts()
                    completion(true)

                case .failure(let error):
                    self.showError(error)
                    completion(false)
                }
            }
        }

        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(
            actions: [deleteAction]
        )

        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}
