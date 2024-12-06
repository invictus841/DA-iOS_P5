//
//  Mocks.swift
//  AuraTests
//
//  Created by Alexandre Talatinian on 23/11/2024.
//

import Foundation
@testable import Aura

// MOCK 1: Network Service Mock
class MockNetworkService: NetworkService {
    var shouldSucceed = true
    var resultToken: String?
    var error: Error?
    var mockData: Any?
    
    func makeRequest<T>(url: URL, method: String, body: Data?, token: String?, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldSucceed {
            if let mockData = mockData as? T {
                completion(.success(mockData))
            } else if let token = resultToken, T.self == [String: String].self {
                let response = ["token": token] as! T
                completion(.success(response))
            } else if T.self == [String: String].self {
                let emptyResponse = [:] as! T
                completion(.success(emptyResponse))
            } else if T.self == EmptyResponse.self {  // Add this case
                completion(.success(EmptyResponse() as! T))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported response type"])))
            }
        } else {
            completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        }
    }
}

// MOCK 2: Keychain Manager Mock
class MockKeychainManager: KeychainManaging {
    var shouldSaveSucceed = true
    var savedToken: String?
    
    func save(_ token: String) -> Bool {
        if shouldSaveSucceed {
            savedToken = token
            return true
        }
        return false
    }
    
    func getToken() -> String? {
        return savedToken
    }
    
    func deleteToken() {
        savedToken = nil
    }
}
