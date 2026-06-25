import Foundation

public struct Post {
    public var author: String
    public var description: String
    public var image: String
    public var likes: Int
    public var views: Int
    
    public init(author: String, description: String, image: String, likes: Int, views: Int) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}

var posts: [Post] = [
    Post(author: "LeoTolstoy", description: "пишу новый роман", image: "leotolstoy", likes: 10, views: 100 ),
    Post(author: "Medinsky", description: "переписываю историю", image: "medinsky", likes: 0, views: 1000 ),
    Post(author: "Selhoznadzor", description: "запрещаю армянскую форель", image: "rshn", likes: 5, views: 120 ),
    Post(author: "Roskomnadzor", description: "блокирую интернет", image: "rkn", likes: 1, views: 10000 )
]

