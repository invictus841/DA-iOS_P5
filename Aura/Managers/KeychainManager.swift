//
//  KeychainManager.swift
//  Aura
//
//  Created by Alexandre Talatinian on 18/11/2024.
//

import Foundation
import Security

// For mock, c'est un squelette
protocol KeychainManaging {
    func save(_ token: String) -> Bool
    func getToken() -> String?
    func deleteToken()
}

class KeychainManager: KeychainManaging {
    static let standard = KeychainManager()
    private init() {} // Singleton
    
    let account = "com.mobilemaker.Aura"  // Change this to your app's bundle ID
    
    func save(_ token: String) -> Bool {
        let tokenData = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData
        ]
        
        // First remove any existing token
        SecItemDelete(query as CFDictionary)
        
        // Then save the new token
        let status = SecItemAdd(query as CFDictionary, nil)
        
        print("token saved")
        return status == errSecSuccess
    }
    
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let tokenData = result as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
