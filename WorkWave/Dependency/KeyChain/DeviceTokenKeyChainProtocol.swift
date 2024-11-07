//
//  DeviceTokenKeyChainProtocol.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation

protocol DeviceTokenKeyChainProtocol {
    var deviceToken: String? { get set }
    func clearTokens()
}
