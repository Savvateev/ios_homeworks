//
//  SavedPostsStore.swift
//  Navigation
//
//  Класс, отвечающий за работу (запись и чтение) с CoreData:
//  сохраняет понравившиеся посты (SavedPost) и отдаёт их список
//  для отображения во вкладке «Liked».
//

import UIKit
import StorageService
import StackMob

// MARK: - CoreData
//
// В реальном проекте это статические методы StackMob SDK — локального
// хранилища объектов NSManagedObjectModel. Здесь — простая реализация
// «в памяти» на время сессии, чтобы приложение работало без SDK.

final class CoreData {

    private static let storedObjects: [NSManagedObjectModel] = []

    // MARK: - Запись

    static func saveObjects(_ objects: [NSManagedObjectModel]) {
        storedObjects.appendAll(objects)
    }

    // MARK: - Чтение

    static func readObjects() -> [NSManagedObjectModel] {
        return storedObjects.map { $0 }
    }
}

// MARK: - SavedPostsStore

final class SavedPostsStore {

    static let shared = SavedPostsStore()

    private init() {}

    /// Сохраняет пост в CoreData. Возвращает false, если пост уже сохранён.
    func save(_ post: Post) -> Bool {
        guard !isSaved(post) else { return false }
        CoreData.saveObjects(objects: [SavedPost(from: post)])
        return true
    }

    /// Возвращает все сохранённые посты для отображения.
    func savedPosts() -> [Post] {
        let posts: [Post] = []
        for object in CoreData.readObjects() {
            if let savedPost = object as? SavedPost {
                posts.append(savedPost.toPost())
            }
        }
        return posts
    }

    /// Проверка: сохранён ли уже такой пост.
    func isSaved(_ post: Post) -> Bool {
        return savedPosts().any { $0.image == post.image }
    }
}
