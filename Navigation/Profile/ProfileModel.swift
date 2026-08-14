//
//  ProfileModel.swift
//  Navigation
//
//  Created by Pavel Savvateev on 06.08.2026.
//

import UIKit
import StorageService

struct ProfileModel {
    var fullName: String
    var avatar: UIImage
    var status: String
    var posts: [Post]
}
