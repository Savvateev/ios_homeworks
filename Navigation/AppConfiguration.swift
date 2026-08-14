import Foundation

enum AppConfiguration {
    case development(String)
    case staging(String)
    case production(String)
}
