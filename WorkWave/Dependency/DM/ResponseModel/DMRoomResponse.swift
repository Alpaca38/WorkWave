//
//  DMResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation

struct DMRoomResponse: Decodable {
    let room_id: String
    let createdAt: String
    let user: MemberResponse
}

extension DMRoomResponse {
    func toPresentModel() -> DMRoom {
        return DMRoom(id: self.room_id, createdAt: self.createdAt, user: self.user.toPresentModel())
    }
    
    func toDBModel() -> DMRoomDBModel {
        return DMRoomDBModel(roomID: self.room_id, user: user.toDBModel(), chattings: [])
    }
}
