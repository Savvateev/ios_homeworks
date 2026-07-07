import UIKit

public struct User {
    let login: String
    let fullName: String
    let avatar: UIImage
    var status: String
}

public protocol UserService {
    func getUser(by login: String) -> User?
}

public class CurrentUserService: UserService {
    
    private let currentUser: User
    
    public init(user: User) {
        self.currentUser = user
    }
    
    public func getUser(by login: String) -> User? {
        guard login == currentUser.login else { return nil }
        return currentUser
    }
}
