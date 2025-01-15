//
//  MemeberDBModel.swift
//  WorkWave
//
//  Created by 조규연 on 1/15/25.
//

import Foundation
import RealmSwift

class MemberDBModel: Object {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(userID: String, email: String, nickname: String, profileImage: String?) {
        self.init()
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension MemberDBModel {
    func toPresentModel() -> Member {
        return Member(id: self.userID, email: self.email, nickname: self.nickname, profileImage: self.profileImage)
    }
}
