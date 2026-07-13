import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

final class Checker {
    
    static let shared = Checker()
    
    private let login = "user"
    private let password = "password"
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        return login == self.login && password == self.password
    }
}

final class LoginInspector: LoginViewControllerDelegate {
    
    private let checker = Checker.shared
    
    func check(login: String, password: String) -> Bool {
        return checker.check(login: login, password: password)
    }
}

struct MyLoginFactory: LoginFactory {
    
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
