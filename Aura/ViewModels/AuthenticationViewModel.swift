//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let networkService: NetworkService  // NEW: injected network service
    private let keychainManager: KeychainManaging  // NEW: injected keychain manager
    let onLoginSucceed: (() -> Void)
    
    init(
        networkService: NetworkService = URLSessionNetworkService(),  // NEW: parameter
        keychainManager: KeychainManaging = KeychainManager.standard,  // NEW: parameter
        onLoginSucceed: @escaping () -> Void
    ) {
        self.networkService = networkService
        self.keychainManager = keychainManager
        self.onLoginSucceed = onLoginSucceed
    }
    
    func login() {
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else { return }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        
        // NEW: Using networkService instead of URLSession directly
        networkService.makeRequest(
            url: url,
            method: "POST",
            body: jsonData,
            token: nil
        ) { [weak self] (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                if let token = response["token"] {
                    // NEW: Using injected keychainManager instead of KeychainManager.standard
                    if self?.keychainManager.save(token) == true {
                        self?.onLoginSucceed()
                    } else {
                        self?.showError = true
                        self?.errorMessage = "Failed to save authentication token"
                    }
                }
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
    
    
//    func login() {
//        // Create URL and URLRequest
//        guard let url = URL(string: "http://127.0.0.1:8080/auth") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Create request body
//        let body: [String: String] = [
//            "username": username,
//            "password": password
//        ]
//        
//        // Convert body to JSON data
//        guard let jsonData = try? JSONEncoder().encode(body) else { return }
//        request.httpBody = jsonData
//        
//        // Make network request
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.showError = true
//                    self?.errorMessage = error.localizedDescription
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse else { return }
//                
//                if httpResponse.statusCode == 200 {
//                    if let data = data,
//                       let json = try? JSONDecoder().decode([String: String].self, from: data),
//                       let token = json["token"] {
//                        // Save token
//                        UserDefaults.standard.set(token, forKey: "authToken")
//                        // Call success callback
//                        self?.onLoginSucceed()
//                    }
//                } else {
//                    self?.showError = true
//                    self?.errorMessage = "Invalid credentials"
//                }
//            }
//        }.resume()


