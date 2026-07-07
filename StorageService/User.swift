//
//  User.swift
//  Navigation
//
//  Created by Pavel Savvateev on 07.07.2026.
//
import UIKit

struct User {
    let login: String
    let fullName: String
    let avatar: UIImage
    var status: String
}

protocol UserService {
    func getUser(by login: String) -> User?
}

class CurrentUserService: UserService {
    
    private let currentUser: User
    
    init(user: User) {
        self.currentUser = user
    }
    
    func getUser(by login: String) -> User? {
        guard login == currentUser.login else { return nil }
        return currentUser
    }
}
