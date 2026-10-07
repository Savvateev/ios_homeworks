import Foundation

enum FeedError: Error, Equatable {
    case invalidText
    case emptyText
}

protocol FeedModelProtocol {
    func check(
        word: String,
        completion: @escaping (Result<Bool, FeedError>) -> Void
    )
}

final class FeedModel: FeedModelProtocol {

    private let secretWord: String

    init(secretWord: String) {
        self.secretWord = secretWord
    }

    func check(
        word: String,
        completion: @escaping (Result<Bool, FeedError>) -> Void
    ) {
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedWord.isEmpty else {
            completion(.failure(.emptyText))
            return
        }

        guard trimmedWord.allSatisfy(\.isLetter) else {
            completion(.failure(.invalidText))
            return
        }

        let isCorrect = trimmedWord.lowercased() == secretWord.lowercased()
        completion(.success(isCorrect))
    }
}
