//
//  NetworkManager.swift
//  Sunny
//
//  Created by Руслан Битюков on 22.12.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func nameCity(forCity city: String) -> String {
        "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=9291c8766b8d1e548d51d59220ccb258&units=metric"
    }
    
    func fetch< T: Decodable> (dataType: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error discription")
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}


