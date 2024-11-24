//
//  NetworkService.swift
//  Aura
//
//  Created by Alexandre Talatinian on 18/11/2024.
//

import Foundation

// For mock, c'est un squelette
protocol NetworkService {
    func makeRequest<T: Decodable>(
        url: URL,
        method: String,
        body: Data?,
        token: String?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

// Real implementation that uses URLSession
class URLSessionNetworkService: NetworkService {
    func makeRequest<T: Decodable>(
        url: URL,
        method: String,
        body: Data?,
        token: String?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
