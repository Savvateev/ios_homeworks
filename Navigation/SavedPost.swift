//
//  SavedPost.swift
//  Navigation
//
//  Модель сохранённой публикации (понравившегося поста).
//

import UIKit
import CoreData
import StorageService

// MARK: - NSManagedObjectModel
//
// Модель Core Data строится программно (без файла .xcdatamodeld).

enum SavedPostModel {

    static let entityName = "SavedPost"

    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = entityName
        entity.managedObjectClassName = NSStringFromClass(SavedPost.self)

        func attribute(_ name: String, type: NSAttributeType) -> NSAttributeDescription {
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = type
            attribute.isOptional = true
            return attribute
        }

        entity.properties = [
            attribute("id", type: .stringAttributeType),       // image — уникальный ключ поста
            attribute("author", type: .stringAttributeType),
            attribute("desc", type: .stringAttributeType),
            attribute("image", type: .stringAttributeType),
            attribute("likes", type: .integer64AttributeType),
            attribute("views", type: .integer64AttributeType)
        ]

        model.entities = [entity]
        return model
    }
}

// MARK: - SavedPost

@objc(SavedPost)
class SavedPost: NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var author: String?
    @NSManaged var desc: String?
    @NSManaged var image: String?
    @NSManaged var likes: Int64
    @NSManaged var views: Int64

    // MARK: - Заполнение из Post

    func fill(with post: Post) {
        id = post.image
        author = post.author
        desc = post.description
        image = post.image
        likes = Int64(post.likes)
        views = Int64(post.views)
    }

    // MARK: - Обратное преобразование для отображения

    func toPost() -> Post {
        return Post(
            author: author ?? "",
            description: desc ?? "",
            image: image ?? "",
            likes: Int(likes),
            views: Int(views)
        )
    }
}
