import Foundation

final class FeedViewModel {

    enum ViewInput {
        case checkButtonDidTap
        case pushButtonDidTap
    }

    enum State: Equatable {
        case waiting
        case checking
        case checked(result: Bool)
        case error(error: FeedError)
    }

    private let feedModel: FeedModelProtocol

    private(set) var state: State = .waiting

    init(feedModel: FeedModelProtocol = FeedModel(secretWord: "password")) {
        self.feedModel = feedModel
    }

    func updateState(viewInput: ViewInput, text: String) {
        switch viewInput {
        case .checkButtonDidTap:
            state = .checking

            feedModel.check(word: text) { [weak self] result in
                switch result {
                case .success(let isCorrect):
                    self?.state = .checked(result: isCorrect)

                case .failure(let error):
                    self?.state = .error(error: error)
                }
            }

        case .pushButtonDidTap:
            break
        }
    }

    // Можно оставить для совместимости с вызовом из FeedViewController.
    func check(word: String) {
        updateState(viewInput: .checkButtonDidTap, text: word)
    }
}
