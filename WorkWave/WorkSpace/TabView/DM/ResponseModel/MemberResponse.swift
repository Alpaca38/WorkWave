//
//  Member.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation

struct MemberResponse: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
}

extension MemberResponse {
    func toPresentModel() -> Member {
        return Member(
            id: self.user_id,
            email: self.email,
            nickname: self.nickname,
            profileImage: self.profileImage
        )
    }
}
