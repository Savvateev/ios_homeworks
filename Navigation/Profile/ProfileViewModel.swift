import UIKit

class ProfileViewModel {
    
    // MARK: - Published State
    
    private(set) var fullName: String = ""
    private(set) var avatar: UIImage?
    private(set) var status: String = ""
    private(set) var posts: [Post] = []
    
    // MARK: - Callbacks
    
    var onProfileUpdated: (() -> Void)?
    var onStatusChanged: ((String) -> Void)?
    
    // MARK: - Private
    
    private var user: User? {
        didSet {
            updateState()
        }
    }
    
    // MARK: - Public Methods
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func setPosts(_ posts: [Post]) {
        self.posts = posts
        onProfileUpdated?()
    }
    
    func updateStatus(_ newStatus: String) {
        user?.status = newStatus
        status = newStatus
        onStatusChanged?(newStatus)
    }
    
    // MARK: - Private
    
    private func updateState() {
        guard let user = user else { return }
        fullName = user.fullName
        avatar = user.avatar
        status = user.status
        onProfileUpdated?()
    }
}
