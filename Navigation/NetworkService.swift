import Foundation

struct NetworkService {

    // JSONSerialization
    static func requestFilmTitle(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://swapi.py4e.com/api/films/1/") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                let nsError = error as NSError
                print("❌ Error: \(error.localizedDescription), Code: \(nsError.code)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = jsonObject as? [String: Any],
                      let title = dict["title"] as? String else {
                    completion(.failure(URLError(.cannotParseResponse)))
                    return
                }
                print("title: \(title)")
                completion(.success(title))

            } catch {
                print("❌ JSONSerialization Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // JSONDecoder
    static func requestPlanet(completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let url = URL(string: "https://swapi.py4e.com/api/planets/1") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                print("✅ Planet: \(planet.name), Orbital Period: \(planet.orbitalPeriod)")
                completion(.success(planet))
            } catch {
                print("❌ JSON Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
