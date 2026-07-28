//
//  FeedModel.swift
//  Navigation
//
//  Created by Pavel Savvateev on 28.07.2026.
//

import Foundation

class FeedModel {
    
    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = "word"
    }
    
    func check(word: String) -> Bool {
        return word.lowercased() == secretWord.lowercased()
    }
}
