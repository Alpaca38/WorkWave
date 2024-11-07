//
//  SignupRequest.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation

struct SignupRequest: Encodable {
    var email: String
    var password: String
    var nickname: String
    var phone: String
    var deviceToken: String
}
