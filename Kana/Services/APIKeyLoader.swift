//
//  APIKeyLoader.swift
//  Kana
//
//  Created by Paul Kim on 10/28/24.
//


import Foundation

class APIKeyLoader {
    /// Static initializer to automatically load and save API keys on launch
    static let shared: Void = {
        loadAPIKeys()
    }()
    
    /// Loads API keys from a `.plist` file and saves them to the Keychain
    static func loadAPIKeys() {
        // The name of the `.plist` file (without the extension)
        let plistName = "Config"
        
        // Get the URL of the .plist file from the main bundle
        guard let plistURL = Bundle.main.url(forResource: plistName, withExtension: "plist"),
              let data = try? Data(contentsOf: plistURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let apiKeys = plist as? [String: String] else {
            print("Failed to load API keys from \(plistName).plist")
            return
        }
        
        // Create an instance of KeychainManager
        let keychainManager = KeychainManager()
        
        // Save each API key to the keychain
        for (key, apiKey) in apiKeys {
            do {
                try keychainManager.saveAPIKey(apiKey, forKey: key)
                print("Successfully saved API key for: \(key)")
            } catch {
                print("Failed to save API key for \(key): \(error)")
            }
        }
    }
}
