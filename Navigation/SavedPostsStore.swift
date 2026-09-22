import Foundation
import CoreData
import StorageService

final class SavedPostsStore {

    static let shared = SavedPostsStore()

    private init() {}

    // MARK: - Persistent Container

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: SavedPostModel.entityName,
            managedObjectModel: SavedPostModel.make()
        )

        guard let storeDescription =
                container.persistentStoreDescriptions.first else {
            fatalError("Не найдено описание Core Data хранилища")
        }

        // Автоматическая миграция существующего хранилища.
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Ошибка загрузки Core Data: \(error)")
            } else {
                print("✅ Core Data успешно загружен")
            }
        }

        return container
    }()

    // MARK: - Contexts

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    // MARK: - Save

    /// Сохранение выполняется в backgroundContext.
    ///
    /// success(true)  — пост сохранён;
    /// success(false) — пост уже существует.
    func save(
        _ post: Post,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let request = NSFetchRequest<SavedPost>(
                entityName: SavedPostModel.entityName
            )

            request.predicate = NSPredicate(
                format: "id == %@",
                post.image
            )
            request.fetchLimit = 1

            do {
                let existingPosts =
                    try self.backgroundContext.fetch(request)

                // Не сохраняем один пост повторно.
                if !existingPosts.isEmpty {
                    DispatchQueue.main.async {
                        completion(.success(false))
                    }
                    return
                }

                let savedPost = SavedPost(
                    context: self.backgroundContext
                )

                savedPost.fill(with: post)

                try self.backgroundContext.save()

                DispatchQueue.main.async {
                    completion(.success(true))
                }

            } catch {
                print("❌ Ошибка сохранения поста: \(error)")

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Read

    /// Чтение всех сохранённых постов.
    func savedPosts() -> [Post] {
        let request = NSFetchRequest<SavedPost>(
            entityName: SavedPostModel.entityName
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "author",
                ascending: true
            )
        ]

        do {
            let objects = try viewContext.fetch(request)
            return objects.map { $0.toPost() }

        } catch {
            print("❌ Ошибка чтения постов: \(error)")
            return []
        }
    }

    // MARK: - Search by author

    /// Поиск сохранённых постов по автору.
    /// Поиск нечувствителен к регистру.
    func savedPosts(byAuthor author: String) -> [Post] {
        let request = NSFetchRequest<SavedPost>(
            entityName: SavedPostModel.entityName
        )

        request.predicate = NSPredicate(
            format: "author ==[c] %@",
            author
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "author",
                ascending: true
            )
        ]

        do {
            let objects = try viewContext.fetch(request)
            return objects.map { $0.toPost() }

        } catch {
            print("❌ Ошибка поиска постов: \(error)")
            return []
        }
    }

    // MARK: - Delete

    /// Удаление выполняется в backgroundContext.
    func delete(
        _ post: Post,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let request = NSFetchRequest<SavedPost>(
                entityName: SavedPostModel.entityName
            )

            request.predicate = NSPredicate(
                format: "id == %@",
                post.image
            )

            do {
                let objects =
                    try self.backgroundContext.fetch(request)

                for object in objects {
                    self.backgroundContext.delete(object)
                }

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }

                DispatchQueue.main.async {
                    completion(.success(()))
                }

            } catch {
                print("❌ Ошибка удаления поста: \(error)")

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Check duplicate

    func isSaved(_ post: Post) -> Bool {
        let request = NSFetchRequest<SavedPost>(
            entityName: SavedPostModel.entityName
        )

        request.predicate = NSPredicate(
            format: "id == %@",
            post.image
        )
        request.fetchLimit = 1

        do {
            return try viewContext.count(for: request) > 0
        } catch {
            print("❌ Ошибка проверки поста: \(error)")
            return false
        }
    }
}
