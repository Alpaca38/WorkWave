//
//  AppleLoginRequest.swift
//  WorkWave
//
//  Created by 조규연 on 1/21/25.
//

import Foundation

struct AppleLoginRequest: Encodable {
    let idToken: String
    let nickname: String
    let deviceToken: String?
}
