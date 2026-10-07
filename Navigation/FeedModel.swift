import Foundation

protocol FeedModelProtocol {
    func check(word: String) -> Bool
}

final class FeedModel: FeedModelProtocol {

    private let secretWord: String

    init(secretWord: String) {
        self.secretWord = secretWord
    }

    func check(word: String) -> Bool {
        word.lowercased() == secretWord.lowercased()
    }
}
