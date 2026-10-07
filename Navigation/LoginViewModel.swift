//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Pavel Savvateev on 07.10.2026.
//


import Foundation

final class LoginViewModel {

    private let service: LoginViewControllerDelegate
    private let shouldAttemptSignUp: (Error) -> Bool
    private let isAlreadyRegistered: (Error) -> Bool

    init(
        service: LoginViewControllerDelegate,
        shouldAttemptSignUp: @escaping (Error) -> Bool,
        isAlreadyRegistered: @escaping (Error) -> Bool
    ) {
        self.service = service
        self.shouldAttemptSignUp = shouldAttemptSignUp
        self.isAlreadyRegistered = isAlreadyRegistered
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.checkCredentials(email: email, password: password) { [self] result in
            switch result {
            case .success:
                completion(.success(()))

            case .failure(let error):
                guard shouldAttemptSignUp(error) else {
                    completion(.failure(error))
                    return
                }

                service.signUp(email: email, password: password) { [self] signUpResult in
                    switch signUpResult {
                    case .success:
                        completion(.success(()))

                    case .failure(let signUpError):
                        if isAlreadyRegistered(signUpError) {
                            completion(.success(()))
                        } else {
                            completion(.failure(signUpError))
                        }
                    }
                }
            }
        }
    }
}
