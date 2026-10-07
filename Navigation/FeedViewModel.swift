//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Pavel Savvateev on 07.10.2026.
//


import Foundation

final class FeedViewModel {

    enum State: Equatable {
        case waiting
        case emptyInput
        case correct
        case incorrect
    }

    private let feedModel: FeedModelProtocol

    private(set) var state: State = .waiting

    init(feedModel: FeedModelProtocol = FeedModel(secretWord: "password")) {
        self.feedModel = feedModel
    }

    func check(word: String) {
        guard !word.isEmpty else {
            state = .emptyInput
            return
        }

        state = feedModel.check(word: word) ? .correct : .incorrect
    }
}
