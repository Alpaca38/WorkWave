//
//  DMChattingDBModel.swift
//  WorkWave
//
//  Created by 조규연 on 1/15/25.
//

import Foundation
import RealmSwift

class DMChattingDBModel: Object {
    @Persisted(primaryKey: true) var dmID: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: MemberDBModel
    
    convenience init(dmID: String, content: String?, createdAt: String, files: [String], user: MemberDBModel) {
        self.init()
        self.dmID = dmID
        self.content = content
        self.createdAt = createdAt
        self.files.append(objectsIn: files)
        self.user = user
    }
}

extension DMChattingDBModel {
    func toPresentModel() -> Chatting {
        return Chatting(id: self.dmID, user: self.user.toPresentModel(), name: self.user.nickname, text: self.content, imageNames: Array(self.files), date: self.createdAt, isMine: self.user.userID == UserDefaultsManager.user.userID, profile: self.user.profileImage)
    }
}
