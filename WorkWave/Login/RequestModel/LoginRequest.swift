//
//  LoginRequest.swift
//  WorkWave
//
//  Created by 조규연 on 11/13/24.
//

import Foundation

struct LoginRequest: Encodable {
    var email: String
    var password: String
    var deviceToken: String
}
