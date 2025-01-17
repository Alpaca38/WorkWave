//
//  DMRoom.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import Foundation

struct DMRoom: Identifiable, Hashable {
    let id: String
    let createdAt: String
    let user: Member
}

extension DMRoom {
    func toDBModel(user: MemberDBModel) -> DMRoomDBModel {
        return DMRoomDBModel(roomID: self.id, user: user, chattings: [])
    }
}

typealias DMRooms = [DMRoom]
