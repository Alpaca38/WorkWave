//
//  DeviceTokenKeyChain.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation
import KeychainAccess

final class DeviceTokenKeyChain: DeviceTokenKeyChainProtocol {
    private let keychain = Keychain(service: "Jo.WorkWave")
    
    var deviceToken: String? {
        get { try? keychain.get("deviceToken") }
        set { try? keychain.set(newValue ?? "", key: "deviceToken") }
    }
    
    func clearTokens() {
        do {
            try keychain.remove("deviceToken")
        } catch let error {
            print("토큰 삭제 중 오류 발생: \(error)")
        }
    }
}
