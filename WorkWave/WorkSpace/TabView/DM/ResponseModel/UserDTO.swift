//
//  UserDTO.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import Foundation

struct UserDTO: Hashable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}
