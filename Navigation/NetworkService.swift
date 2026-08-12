//
//  NetworkService.swift
//  Navigation
//
//  Created by Pavel Savvateev on 12.08.2026.
//
import Foundation

struct NetworkService {

    static func request(for configuration: AppConfiguration) {
        let urlString: String

        switch configuration {
        case .development(let string):
            urlString = string
        case .staging(let string):
            urlString = string
        case .production(let string):
            urlString = string
        }
        
        print(urlString)

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(url," ❌ Error: \(error.localizedDescription)")
                return
            }

            if let data = data,
               let dataString = String(data: data, encoding: .utf8) {
                print("✅ Data:\n\(dataString)")
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status Code: \(httpResponse.statusCode)")
                print("📡 All Header Fields: \(httpResponse.allHeaderFields)")
            }
        }

        task.resume()
    }
}
