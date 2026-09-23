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

        // Автоматическая миграция хранилища.
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true

        // Изменения из backgroundContext автоматически попадают
        // в viewContext, который использует NSFetchedResultsController.
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

    /// Контекст для NSFetchedResultsController.
    /// Использовать только в основном потоке.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// Контекст для сохранения и удаления.
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()

        context.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()

    // MARK: - Fetch Request

    /// Fetch Request используется NSFetchedResultsController.
    ///
    /// author:
    /// - nil — получить все посты;
    /// - строка — получить посты указанного автора.
    func makeFetchRequest(
        author: String? = nil
    ) -> NSFetchRequest<SavedPost> {
        let request = NSFetchRequest<SavedPost>(
            entityName: SavedPostModel.entityName
        )

        if let author = author,
           !author.trimmingCharacters(
                in: .whitespacesAndNewlines
           ).isEmpty {

            request.predicate = NSPredicate(
                format: "author CONTAINS[cd] %@",
                author
            )
        }

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "author",
                ascending: true
            ),
            NSSortDescriptor(
                key: "id",
                ascending: true
            )
        ]

        // Небольшая оптимизация для большого количества записей.
        request.fetchBatchSize = 20
        request.fetchLimit = 0

        return request
    }

    // MARK: - Save

    /// Сохранение выполняется в backgroundContext.
    ///
    /// success(true)  — пост сохранён;
    /// success(false) — пост уже существует;
    /// failure        — произошла ошибка Core Data.
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
                let existingPosts = try self.backgroundContext.fetch(request)

                // Защита от повторного сохранения одного поста.
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

    // MARK: - Delete

    /// Удаляет объект по objectID в backgroundContext.
    ///
    /// Важно: объект SavedPost из viewContext нельзя напрямую передавать
    /// в backgroundContext. Поэтому передаём только его objectID.
    func delete(
        objectID: NSManagedObjectID,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            do {
                let object = try self.backgroundContext.existingObject(
                    with: objectID
                )

                self.backgroundContext.delete(object)

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

    // MARK: - Duplicate Check

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
