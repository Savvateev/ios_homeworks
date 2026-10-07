//
//  FeedViewModelTests.swift
//  Navigation
//
//  Created by Pavel Savvateev on 07.10.2026.
//


import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {

    func testCheckWithEmptyInputSetsEmptyInputState() {
        let model = FeedModelMock(result: true)
        let viewModel = FeedViewModel(feedModel: model)

        viewModel.check(word: "")

        XCTAssertEqual(viewModel.state, .emptyInput)
        XCTAssertFalse(model.wasCalled)
    }

    func testCheckWithCorrectWordSetsCorrectState() {
        let model = FeedModelMock(result: true)
        let viewModel = FeedViewModel(feedModel: model)

        viewModel.check(word: "password")

        XCTAssertEqual(viewModel.state, .correct)
        XCTAssertTrue(model.wasCalled)
        XCTAssertEqual(model.receivedWord, "password")
    }

    func testCheckWithIncorrectWordSetsIncorrectState() {
        let model = FeedModelMock(result: false)
        let viewModel = FeedViewModel(feedModel: model)

        viewModel.check(word: "wrong")

        XCTAssertEqual(viewModel.state, .incorrect)
        XCTAssertTrue(model.wasCalled)
        XCTAssertEqual(model.receivedWord, "wrong")
    }
}

private final class FeedModelMock: FeedModelProtocol {

    let result: Bool
    private(set) var wasCalled = false
    private(set) var receivedWord: String?

    init(result: Bool) {
        self.result = result
    }

    func check(word: String) -> Bool {
        wasCalled = true
        receivedWord = word
        return result
    }
}
