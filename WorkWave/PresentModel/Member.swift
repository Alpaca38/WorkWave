//
//  Member.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation

struct Member: Identifiable, Hashable {
    let id: String
    let email: String
    let nickname: String
    let profileImage: String?
}
