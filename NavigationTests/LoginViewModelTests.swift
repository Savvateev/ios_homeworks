//
//  LoginViewModelTests.swift
//  Navigation
//
//  Created by Pavel Savvateev on 07.10.2026.
//


import XCTest
@testable import Navigation

final class LoginViewModelTests: XCTestCase {

    func testLoginSucceedsWithoutSignUpWhenCredentialsAreValid() {
        let service = LoginServiceMock()
        let viewModel = makeViewModel(service: service)

        let result = login(viewModel)

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.checkCredentialsCallCount, 1)
        XCTAssertEqual(service.signUpCallCount, 0)
    }

    func testLoginAttemptsSignUpAfterInvalidCredentials() {
        let service = LoginServiceMock()
        service.credentialsResult = .failure(makeError(code: 401))
        let viewModel = makeViewModel(service: service)

        let result = login(viewModel)

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.checkCredentialsCallCount, 1)
        XCTAssertEqual(service.signUpCallCount, 1)
    }

    func testLoginReturnsFailureForOtherCredentialErrors() {
        let service = LoginServiceMock()
        service.credentialsResult = .failure(makeError(code: 500))
        let viewModel = makeViewModel(service: service)

        let result = login(viewModel)

        XCTAssertEqual(service.signUpCallCount, 0)

        guard case .failure(let error) = result else {
            return XCTFail("Expected login to fail")
        }

        XCTAssertEqual((error as NSError).code, 500)
    }

    func testLoginSucceedsWhenSignUpReportsExistingUser() {
        let service = LoginServiceMock()
        service.credentialsResult = .failure(makeError(code: 401))
        service.signUpResult = .failure(makeError(code: 409))
        let viewModel = makeViewModel(service: service)

        let result = login(viewModel)

        XCTAssertTrue(isSuccess(result))
        XCTAssertEqual(service.signUpCallCount, 1)
    }

    // MARK: - Helpers

    private func makeViewModel(
        service: LoginServiceMock
    ) -> LoginViewModel {
        LoginViewModel(
            service: service,
            shouldAttemptSignUp: { error in
                (error as NSError).code == 401
            },
            isAlreadyRegistered: { error in
                (error as NSError).code == 409
            }
        )
    }

    private func login(
        _ viewModel: LoginViewModel
    ) -> Result<Void, Error>? {
        var result: Result<Void, Error>?

        viewModel.login(email: "test@example.com", password: "password") {
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
