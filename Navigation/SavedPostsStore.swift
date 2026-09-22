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

    // MARK: - View Context

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Background Context

    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()

        context.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()

    // MARK: - Сохранение

    /// Сохраняет пост в backgroundContext.
    ///
    /// success(true)  — пост сохранён;
    /// success(false) — пост уже существует;
    /// failure        — ошибка Core Data.
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

                // Не добавляем одинаковый пост повторно.
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

    // MARK: - Чтение всех постов

    /// Чтение выполняется из viewContext.
    /// Метод вызывается из главного потока, так как результат используется UI.
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
            let savedPosts = try viewContext.fetch(request)
            return savedPosts.map { $0.toPost() }

        } catch {
            print("❌ Ошибка чтения постов: \(error)")
            return []
        }
    }

    // MARK: - Поиск по автору

    /// Возвращает посты указанного автора.
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
            let savedPosts = try viewContext.fetch(request)
            return savedPosts.map { $0.toPost() }

        } catch {
            print("❌ Ошибка поиска постов: \(error)")
            return []
        }
    }

    // MARK: - Удаление

    /// Удаляет пост в backgroundContext.
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
                let savedPosts = try self.backgroundContext.fetch(request)

                for savedPost in savedPosts {
                    self.backgroundContext.delete(savedPost)
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

    // MARK: - Проверка

    func isSaved(_ post: Post) -> Bool {
        return savedPosts().contains {
            $0.image == post.image
        }
    }
}
