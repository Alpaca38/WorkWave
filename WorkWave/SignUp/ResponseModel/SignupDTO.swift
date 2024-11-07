//
//  SignupDTO.swift
//  WorkWave
//
//  Created by 조규연 on 11/7/24.
//

import Foundation

struct SignupDTO: Decodable {
    let userID, email, nickname, profileImage: String
    let phone, provider: String?
    let createdAt: String
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, provider, createdAt, token
    }
}

struct Token: Decodable {
    var accessToken: String
    var refreshToken: String
}
