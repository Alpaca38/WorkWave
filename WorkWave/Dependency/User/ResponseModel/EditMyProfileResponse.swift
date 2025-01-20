//
//  EditMyProfileResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/14/25.
//

import Foundation

struct EditMyProfileResponse: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case createdAt
    }
}
