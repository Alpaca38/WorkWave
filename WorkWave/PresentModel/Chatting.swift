//
//  Chatting.swift
//  WorkWave
//
//  Created by 조규연 on 1/12/25.
//

import Foundation

struct Chatting: Identifiable {
    var id: String
    let user: Member
    let name: String
    let text: String?
    let imageNames: [String]
    let date: String
    let isMine: Bool
    let profile: String?
}
