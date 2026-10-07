import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {

    func testSuccessTrueSetsCheckedTrueState() {
        let model = FeedModelMock()
        model.fakeResult = .success(true)

        let viewModel = FeedViewModel(feedModel: model)
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "password"
        )

        XCTAssertEqual(viewModel.state, .checked(result: true))
    }

    func testSuccessFalseSetsCheckedFalseState() {
        let model = FeedModelMock()
        model.fakeResult = .success(false)

        let viewModel = FeedViewModel(feedModel: model)
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "wrong"
        )

        XCTAssertEqual(viewModel.state, .checked(result: false))
    }

    func testEmptyTextErrorSetsErrorState() {
        let model = FeedModelMock()
        model.fakeResult = .failure(.emptyText)

        let viewModel = FeedViewModel(feedModel: model)
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: ""
        )

        XCTAssertEqual(viewModel.state, .error(error: .emptyText))
    }

    func testInvalidTextErrorSetsErrorState() {
        let model = FeedModelMock()
        model.fakeResult = .failure(.invalidText)

        let viewModel = FeedViewModel(feedModel: model)
        viewModel.updateState(
            viewInput: .checkButtonDidTap,
            text: "pass123"
        )

        XCTAssertEqual(viewModel.state, .error(error: .invalidText))
    }
}

private final class FeedModelMock: FeedModelProtocol {

    var fakeResult: Result<Bool, FeedError> = .success(false)

    func check(
        word: String,
        completion: @escaping (Result<Bool, FeedError>) -> Void
    ) {
        completion(fakeResult)
    }
}
