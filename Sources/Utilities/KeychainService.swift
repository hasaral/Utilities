//
//  KeychainService.swift
//  Utilities
//
//  Created by Hasan Saral on 17.12.2024.
//


import Foundation

struct KeychainService {
    
    func save(_ password: String, for key: String) {
        if let data = password.data(using: String.Encoding.utf8) {
            save(data, for: key)
        }
    }
    func retrivePassword(for key: String) -> String? {
        if let data = retriveData(for: key) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
    internal func save(_ data: Data, for key: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
            print("Error: \(status)")
        }
    }
    func delete(key: String) {
        let query = [
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        // Delete item from keychain
        SecItemDelete(query)
    }
    internal func retriveData(for key: String) -> Data? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else { return nil }
        return data
    }
    
    func save<T: Codable>(_ obj: T, for key: String) {
        if let data = try? JSONEncoder().encode(obj) {
            save(data, for: key)
        }
    }
    func retrive<T: Codable>(for key: String) -> T? {
        if let data = retriveData(for: key) {
            if let obj = try? JSONDecoder().decode(T.self, from: data) {
                return obj
            }
        }
        return nil
    }
}
