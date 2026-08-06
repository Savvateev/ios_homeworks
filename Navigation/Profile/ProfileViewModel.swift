import UIKit
import StorageService

class ProfileViewModel {
    
    // MARK: - Model (единственный источник)
    
    private var profileModel: ProfileModel? {
        didSet {
            updateState() // срабатывает при ЛЮБОМ изменении любого поля
        }
    }
    
    // MARK: - Published State
    
    private(set) var fullName: String = ""
    private(set) var avatar: UIImage = UIImage()
    private(set) var status: String = ""
    private(set) var posts: [Post] = []
    
    // MARK: - Callbacks
    
    var onProfileUpdated: (() -> Void)?
    
    // MARK: - Public Methods
    
    func setUser(_ user: User) {
        profileModel = ProfileModel(
            fullName: user.fullName,
            avatar: user.avatar,
            status: user.status,
            posts: profileModel?.posts ?? []
        )
    }
    
    func setPosts(_ posts: [Post]) {
        guard var model = profileModel else { return }
        model.posts = posts
        profileModel = model // переприсваивание → didSet
    }
    
    func updateStatus(_ newStatus: String) {
        guard var model = profileModel else { return }
        model.status = newStatus
        profileModel = model // переприсваивание → didSet
    }
    
    // MARK: - Private
    
    private func updateState() {
        guard let model = profileModel else { return }
        fullName = model.fullName
        avatar = model.avatar
        status = model.status
        posts = model.posts
        onProfileUpdated?()
    }
}
