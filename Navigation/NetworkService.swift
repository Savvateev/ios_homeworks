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

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                let nsError = error as NSError
                print("❌ Error: \(error.localizedDescription)")
                print("❌ Error Code: \(nsError.code)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("All Header Fields: \(httpResponse.allHeaderFields)")
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                print("Planet: \(planet.name)")
                print("Orbital Period: \(planet.orbitalPeriod) days")

                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("OrbitalPeriodReceived"),
                        object: nil,
                        userInfo: ["orbitalPeriod": planet.orbitalPeriod]
                    )
                }

            } catch {
                print("❌ JSON Decoding Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
