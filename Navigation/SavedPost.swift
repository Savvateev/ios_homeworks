import Foundation
import CoreData
import StorageService

// MARK: - Core Data Model

enum SavedPostModel {

    static let entityName = "SavedPost"

    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = entityName
        entity.managedObjectClassName = NSStringFromClass(SavedPost.self)

        // MARK: - Helpers

        func makeStringAttribute(
            name: String,
            indexed: Bool = false
        ) -> NSAttributeDescription {
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = .stringAttributeType
            attribute.isOptional = false
            attribute.defaultValue = ""
            attribute.isIndexed = indexed
            return attribute
        }

        func makeIntegerAttribute(
            name: String
        ) -> NSAttributeDescription {
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = .integer64AttributeType
            attribute.isOptional = false
            attribute.defaultValue = 0
            return attribute
        }

        // MARK: - Attributes

        entity.properties = [
            // Используется как уникальный идентификатор поста.
            // В текущей модели Post отдельного id нет,
            // поэтому используется имя изображения.
            makeStringAttribute(
                name: "id",
                indexed: true
            ),

            // Индекс ускоряет поиск по автору.
            makeStringAttribute(
                name: "author",
                indexed: true
            ),

            makeStringAttribute(name: "desc"),
            makeStringAttribute(name: "image"),

            makeIntegerAttribute(name: "likes"),
            makeIntegerAttribute(name: "views")
        ]

        // Запрещает хранить несколько объектов с одинаковым id.
        entity.uniquenessConstraints = [
            ["id"]
        ]

        model.entities = [entity]

        return model
    }
}

// MARK: - Managed Object

@objc(SavedPost)
final class SavedPost: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var author: String
    @NSManaged var desc: String
    @NSManaged var image: String
    @NSManaged var likes: Int64
    @NSManaged var views: Int64

    // MARK: - Post → SavedPost

    func fill(with post: Post) {
        id = post.image
        author = post.author
        desc = post.description
        image = post.image
        likes = Int64(post.likes)
        views = Int64(post.views)
    }

    // MARK: - SavedPost → Post

    func toPost() -> Post {
        return Post(
            author: author,
            description: desc,
            image: image,
            likes: Int(likes),
            views: Int(views)
        )
    }
}
