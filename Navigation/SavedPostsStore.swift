//
//  SavedPostsStore.swift
//  Navigation
//
//  Класс, отвечающий за работу (запись и чтение) с Core Data:
//  сохраняет понравившиеся посты и отдаёт их список для вкладки «Liked».
//

import UIKit
import CoreData
import StorageService

final class SavedPostsStore {

    static let shared = SavedPostsStore()
    private init() {}

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: SavedPostModel.entityName,
            managedObjectModel: SavedPostModel.make()
        )
        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Не удалось загрузить хранилище Core Data: \(error)")
            }
        }
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Запись

    /// Сохраняет пост в Core Data. Возвращает false, если пост уже сохранён.
    @discardableResult
    func save(_ post: Post) -> Bool {
        guard !isSaved(post) else { return false }

        let savedPost = SavedPost(context: viewContext)
        savedPost.fill(with: post)

        do {
            try viewContext.save()
            return true
        } catch {
            print("❌ Ошибка сохранения в Core Data: \(error)")
            return false
        }
    }

    // MARK: - Чтение

    /// Возвращает все сохранённые посты для отображения.
    func savedPosts() -> [Post] {
        let fetchRequest = NSFetchRequest<SavedPost>(entityName: SavedPostModel.entityName)

        do {
            let saved = try viewContext.fetch(fetchRequest)
            return saved.map { $0.toPost() }
        } catch {
            print("❌ Ошибка чтения из Core Data: \(error)")
            return []
        }
    }

    /// Проверка: сохранён ли уже такой пост.
    func isSaved(_ post: Post) -> Bool {
        return savedPosts().contains { $0.image == post.image }
    }
}
