import Foundation

struct Post {
    var author: String
    var description: String
    var image: String
    var likes: Int
    var views: Int
}

var posts: [Post] = [
    Post(author: "LeoTolstoy", description: "пишу новый роман", image: "leotolstoy", likes: 10, views: 100 ),
    Post(author: "Medinsky", description: "переписываю историю", image: "medinsky", likes: 0, views: 1000 ),
    Post(author: "Selhoznadzor", description: "запрещаю армянскую форель", image: "rshn", likes: 5, views: 120 ),
    Post(author: "Roskomnadzor", description: "блокирую интернет", image: "rkn", likes: 1, views: 10000 )
]

