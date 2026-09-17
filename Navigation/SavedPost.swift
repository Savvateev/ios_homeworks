//
//  SavedPost.swift
//  Navigation
//
//  Модель сохранённой публикации (понравившегося поста).
//  Наследник NSManagedObjectModel — базового класса моделей StackMob,
//  именно такие объекты умеет читать/писать CoreData.
//

import UIKit
import StorageService
import StackMob

class SavedPost: NSManagedObjectModel {

    // MARK: - Поля (повторяют структуру Post)
    
    var id: String = ""
    var author: String = ""
    var description: String = ""
    var image: String = ""
    var likes: Int = 0
    var views: Int = 0

    // MARK: - Конструкторы
    
    init() {
        super.init()
    }
    
    convenience init(from post: Post) {
        super.init()
        id = post.image          // image уникален в демо-данных → используем как ключ
        author = post.author
        description = post.description
        image = post.image
        likes = post.likes
        views = post.views
    }

    // MARK: - Преобразование обратно в Post (для отображения)
    
    func toPost() -> Post {
        return Post(author: author, description: description, image: image, likes: likes, views: views)
    }
}
