//
//  DMRoom.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import Foundation

struct DMRoom: Identifiable, Hashable {
    let id = UUID()
    let room_id: String
    let createdAt: String
    let user: UserDTO
}

typealias DMRooms = [DMRoom]
