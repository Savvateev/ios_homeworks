import Foundation

struct NetworkService {

    static func requestPlanet(completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let url = URL(string: "https://swapi.py4e.com/api/planets/1") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                let nsError = error as NSError
                print("❌ Error: \(error.localizedDescription)")
                print("❌ Error Code: \(nsError.code)")
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
