//
//  KeychainManager.swift
//  Kana
//
//  Created by Paul Kim on 10/24/24.
//

import Foundation

class KeychainManager {
    /// Represents possible errors when interacting with the Keychain
    enum KeychainError: LocalizedError {
        case duplicateItem
        case itemNotFound
        case unhandledError(status: OSStatus)
        
        var errorDescription: String? {
            switch self {
            case .duplicateItem:
                return "A duplicate item was found in the keychain"
            case .itemNotFound:
                return "The requested item could not be found in the keychain"
            case .unhandledError(let status):
                return "An unhandled error occurred: \(status)"
            }
        }
    }
    
    /// Service identifier for your app
    private let service: String
    
    /// Initialize with your app's service identifier
    /// If no service is provided, uses the app's bundle identifier
    init(service: String? = nil) {
        if let providedService = service {
            self.service = providedService
        } else {
            // Use the main bundle identifier or fall back to a default
            self.service = Bundle.main.bundleIdentifier?.appending(".keychain") ?? "com.peekay.kana.keychain"
        }
    }
    
    /// Save an API key to the Keychain
    /// - Parameters:
    ///   - key: The identifier for the API key (e.g., "anthropic", "openai")
    ///   - apiKey: The actual API key to store
    func saveAPIKey(_ apiKey: String, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: apiKey.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, try updating instead
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: apiKey.data(using: .utf8)!
            ]
            
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            
            if updateStatus != errSecSuccess {
                throw KeychainError.unhandledError(status: updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Retrieve an API key from the Keychain
    /// - Parameter key: The identifier for the API key to retrieve
    /// - Returns: The stored API key if found
    func getAPIKey(forKey key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            throw KeychainError.unhandledError(status: errSecDecode)
        }
        
        return apiKey
    }
    
    /// Delete an API key from the Keychain
    /// - Parameter key: The identifier for the API key to delete
    func deleteAPIKey(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Check if an API key exists in the Keychain
    /// - Parameter key: The identifier for the API key to check
    /// - Returns: True if the key exists, false otherwise
    func hasAPIKey(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
