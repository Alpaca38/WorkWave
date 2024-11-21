//
//  KeyChainManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation

protocol JWTKeyChainProtocol {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func updateAccessToken(accessToken: String)
    func handleLoginSuccess(accessToken: String, refreshToken: String)
    func clearTokens()
}
