//
//  DMResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation

struct DMResponse: Decodable {
    let room_id: String
    let createdAt: String
    let user: MemberResponse
}

extension DMResponse {
    func toPresentModel() -> DMRoom {
        return DMRoom(id: self.room_id, createdAt: self.createdAt, user: self.user.toPresentModel())
    }
}
