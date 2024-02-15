//
//  KeyChain.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//

import Foundation

import KeychainSwift

protocol KeyChainProtocol {
    func save(token: String)
    func getToken() -> String?
    func deleteToken()
}

final class KeyChain: KeyChainProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
        
    }
    
    func deleteToken() {
        keychain.delete(Key.token)
    }
}
