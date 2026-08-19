import Foundation
import Supabase

// MARK: - Protocols (не меняются)

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol LoginViewControllerDelegate: AnyObject {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

// MARK: - Конфигурация Supabase

enum SupabaseConfig {
    static let projectURL = URL(string: "https://bkpdvuuocxvaofpstdbh.supabase.co")!
    static let anonKey = "sb_publishable_7BmY8_WU-1cOTTTiq8SrQg_IVGYAgYd"
}

// MARK: - CheckerService

final class CheckerService: CheckerServiceProtocol {

    static let shared = CheckerService()

    private let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: SupabaseConfig.projectURL,
            supabaseKey: SupabaseConfig.anonKey
        )
    }

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let _ = try await client.auth.signIn(email: email, password: password)
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let _ = try await client.auth.signUp(email: email, password: password)
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - LoginInspector (не меняется)

final class LoginInspector: LoginViewControllerDelegate {

    private let checkerService = CheckerService.shared

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}

// MARK: - Factory (не меняется)

struct MyLoginFactory: LoginFactory {

    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
