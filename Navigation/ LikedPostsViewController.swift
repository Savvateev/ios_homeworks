import UIKit
import CoreData
import StorageService

final class LikedPostsViewController: UIViewController {

    // MARK: - Properties

    private let savedPostsStore = SavedPostsStore.shared

    private var fetchedResultsController:
        NSFetchedResultsController<SavedPost>!

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
        setupFetchedResultsController()
        performFetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Обновляем FRC после сохранения поста в другом экране.
        performFetch()
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

        // Кнопка поиска и кнопка очистки фильтра.
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
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

    // MARK: - NSFetchedResultsController

    private func setupFetchedResultsController() {
        let fetchRequest = savedPostsStore.makeFetchRequest(
            author: authorFilter
        )

        fetchedResultsController = NSFetchedResultsController<SavedPost>(
            fetchRequest: fetchRequest,
            managedObjectContext: savedPostsStore.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self
    }

    private func performFetch() {
        guard let fetchedResultsController else {
            return
        }

        do {
            try fetchedResultsController.performFetch()
            updateEmptyState()
            tableView.reloadData()
        } catch {
            print("❌ Ошибка выполнения fetch: \(error)")
            showError(error)
        }
    }

    private func recreateFetchedResultsController() {
        fetchedResultsController?.delegate = nil

        setupFetchedResultsController()
        performFetch()
    }

    private func updateEmptyState() {
        let postsCount = fetchedResultsController
            .fetchedObjects?
            .count ?? 0

        if postsCount == 0 {
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

            guard let self else {
                return
            }

            let author = alert?
                .textFields?
                .first?
                .text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

            self.authorFilter = author.isEmpty ? nil : author
            self.recreateFetchedResultsController()
        }

        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )

        alert.addAction(applyAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    // MARK: - Clear Filter

    @objc private func clearFilterButtonTapped() {
        authorFilter = nil
        recreateFetchedResultsController()
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
        return fetchedResultsController
            .fetchedObjects?
            .count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as! PostTableViewCell

        let savedPost = fetchedResultsController.object(
            at: indexPath
        )

        cell.configure(
            with: savedPost.toPost()
        )

        // Повторное сохранение из вкладки Liked не требуется.
        cell.onDoubleTap = nil

        return cell
    }
}

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

            guard let self else {
                completion(false)
                return
            }

            // Берём объект из FRC.
            let savedPost = self.fetchedResultsController.object(
                at: indexPath
            )

            // Передаём в backgroundContext только objectID.
            let objectID = savedPost.objectID

            self.savedPostsStore.delete(
                objectID: objectID
            ) { [weak self] result in

                guard let self else {
                    completion(false)
                    return
                }

                switch result {
                case .success:
                    /*
                     Не вызываем tableView.deleteRows вручную.

                     После удаления в backgroundContext:
                     1. изменение попадёт в viewContext;
                     2. NSFetchedResultsController получит событие;
                     3. NSFetchedResultsControllerDelegate сам удалит строку.
                     */
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

// MARK: - NSFetchedResultsControllerDelegate

extension LikedPostsViewController:
    NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath else {
                return
            }

            tableView.insertRows(
                at: [newIndexPath],
                with: .automatic
            )

        case .delete:
            guard let indexPath else {
                return
            }

            tableView.deleteRows(
                at: [indexPath],
                with: .automatic
            )

        case .update:
            if let indexPath {
                tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic
                )
            }

        case .move:
            guard let indexPath,
                  let newIndexPath else {
                return
            }

            tableView.moveRow(
                at: indexPath,
                to: newIndexPath
            )

        @unknown default:
            tableView.reloadData()
        }
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.endUpdates()
        updateEmptyState()
    }
}
