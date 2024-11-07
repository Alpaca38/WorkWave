//
//  DefaultKeyChainManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation
import KeychainAccess

final class JWTKeyChain: JWTKeyChainProtocol {
    private let keychain = Keychain(service: "Jo.WorkWave")
    
    var accessToken: String? {
        get { try? keychain.get("accessToken") }
        set { try? keychain.set(newValue ?? "", key: "accessToken") }
    }
    
    var refreshToken: String? {
        get { try? keychain.get("refreshToken") }
        set { try? keychain.set(newValue ?? "", key: "refreshToken") }
    }
    
    func handleLoginSuccess(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearTokens() {
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
        } catch let error {
            print("토큰 삭제 중 오류 발생: \(error)")
        }
    }
    
}
