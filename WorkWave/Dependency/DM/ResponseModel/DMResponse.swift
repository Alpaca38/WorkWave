//
//  DMResponse.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import Foundation

struct DMResponse: Decodable {
    let dm_id: String
    let room_id: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MemberResponse
}

extension DMResponse {
    func toPresentModel() -> Chatting {
        return Chatting(
            id: self.dm_id,
            user: self.user.toPresentModel(),
            name: self.user.nickname,
            text: self.content,
            imageNames: self.files,
            date: self.createdAt,
            isMine: user.user_id == UserDefaultsManager.user.userID,
            profile: user.profileImage
        )
    }
    
    func toDBModel(_ user: MemberDBModel) -> DMChattingDBModel {
        return DMChattingDBModel(dmID: self.dm_id, content: self.content, createdAt: self.createdAt, files: self.files, user: user)
    }
}
