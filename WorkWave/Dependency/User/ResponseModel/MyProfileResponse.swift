//
//  MyProfileResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/9/25.
//

import Foundation

struct MyProfileResponse: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let sesacCoin: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case sesacCoin
        case createdAt
    }
}

extension MyProfileResponse {
    func toDBModel() -> MemberDBModel {
        return MemberDBModel(userID: self.userID, email: self.email, nickname: self.nickname, profileImage: self.profileImage)
    }
}
