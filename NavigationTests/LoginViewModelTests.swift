import XCTest
@testable import Navigation

final class LoginViewModelTests: XCTestCase {

    private var service: LoginServiceMock!
    private var viewModel: LoginViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        service = LoginServiceMock()

        viewModel = LoginViewModel(
            service: service,
            shouldAttemptSignUp: { error in
                (error as NSError).code == 401
            },
            isAlreadyRegistered: { error in
                (error as NSError).code == 409
            }
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
        try super.tearDownWithError()
    }

    func testSuccessfulLoginDoesNotAttemptSignUp() {
        service.credentialsResult = .success(())

        let result = login()

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.checkCredentialsCallCount, 1)
        XCTAssertEqual(service.signUpCallCount, 0)
    }

    func testInvalidCredentialsAttemptSignUp() {
        service.credentialsResult = .failure(makeError(code: 401))
        service.signUpResult = .success(())

        let result = login()

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.checkCredentialsCallCount, 1)
        XCTAssertEqual(service.signUpCallCount, 1)
    }

    func testOtherLoginErrorIsReturnedWithoutSignUp() {
        let expectedErrorCode = 500
        service.credentialsResult = .failure(makeError(code: expectedErrorCode))

        let result = login()

        XCTAssertEqual(service.signUpCallCount, 0)

        guard case .failure(let error) = result else {
            return XCTFail("Ожидалась ошибка входа")
        }

        XCTAssertEqual((error as NSError).code, expectedErrorCode)
    }

    func testAlreadyRegisteredUserIsTreatedAsSuccessfulLogin() {
        service.credentialsResult = .failure(makeError(code: 401))
        service.signUpResult = .failure(makeError(code: 409))

        let result = login()

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.signUpCallCount, 1)
    }

    func testSignUpErrorIsReturned() {
        let expectedErrorCode = 500
        service.credentialsResult = .failure(makeError(code: 401))
        service.signUpResult = .failure(makeError(code: expectedErrorCode))

        let result = login()

        guard case .failure(let error) = result else {
            return XCTFail("Ожидалась ошибка регистрации")
        }

        XCTAssertEqual((error as NSError).code, expectedErrorCode)
    }

    // MARK: - Helpers

    private func login() -> Result<Void, Error>? {
        var result: Result<Void, Error>?

        viewModel.login(
            email: "test@example.com",
            password: "password"
        ) {
            result = $0
        }

        return result
    }

    private func isSuccess(_ result: Result<Void, Error>?) -> Bool {
        guard let result else { return false }

        if case .success = result {
            return true
        }

        return false
    }

    private func makeError(code: Int) -> NSError {
        NSError(
            domain: "LoginViewModelTests",
            code: code
        )
    }
}

private final class LoginServiceMock: LoginViewControllerDelegate {

    var credentialsResult: Result<Void, Error> = .success(())
    var signUpResult: Result<Void, Error> = .success(())

    private(set) var checkCredentialsCallCount = 0
    private(set) var signUpCallCount = 0

    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        checkCredentialsCallCount += 1
        completion(credentialsResult)
    }

    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        signUpCallCount += 1
        completion(signUpResult)
    }

    func currentUserEmail() -> String? {
        "test@example.com"
    }
}
