//
//  UnreadDMsResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/12/25.
//

import Foundation

struct UnreadDMsResponse: Decodable {
    let room_id: String
    let count: Int
}
