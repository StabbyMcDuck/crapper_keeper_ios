//
//  Credentials.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import KeychainSwift
import Foundation

struct Credentials {
    static let uidKeychainKey = "uid"
    static let oauthTokenKeychainKey = "oauthToken"
    
    let user: String
    let password: String
    
    static func delete() -> Void {
        let keychain = KeychainSwift()
        keychain.delete(uidKeychainKey)
        keychain.delete(oauthTokenKeychainKey)
    }
    
    static func get() -> Credentials? {
        let keychain = KeychainSwift()
        var credentials: Credentials? = nil
        
        if let uid = keychain.get(uidKeychainKey), let oauthToken = keychain.get(oauthTokenKeychainKey) {
                credentials = Credentials(user: uid, password: oauthToken)
        }
        
        return credentials
    }
    
    static func set(user: String, password: String) -> Void {
        let keychain = KeychainSwift()
        keychain.set(user, forKey: uidKeychainKey)
        keychain.set(password, forKey: oauthTokenKeychainKey)
    }
}
