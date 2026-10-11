import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {

    private var viewModel: FeedViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let realModel = FeedModel(secretWord: "password")
        viewModel = FeedViewModel(feedModel: realModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testCorrectSecretWordSetsCheckedTrueState() {
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "password"
        )

        XCTAssertEqual(viewModel.state, .checked(result: true))
    }

    func testDifferentWordSetsCheckedFalseState() {
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "anotherword"
        )

        XCTAssertEqual(viewModel.state, .checked(result: false))
    }

    func testEmptyInputSetsEmptyTextErrorState() {
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: ""
        )

        XCTAssertEqual(viewModel.state, .error(error: .emptyText))
    }

    func testInputWithNonLettersSetsInvalidTextErrorState() {
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "password123"
        )

        XCTAssertEqual(viewModel.state, .error(error: .invalidText))
    }
}
