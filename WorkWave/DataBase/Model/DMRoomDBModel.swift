//
//  DMRoomDBModel.swift
//  WorkWave
//
//  Created by 조규연 on 1/15/25.
//

import Foundation
import RealmSwift

class DMRoomDBModel: Object {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var user: MemberDBModel
    @Persisted var chattings: List<DMChattingDBModel>
    
    convenience init(roomID: String, user: MemberDBModel, chattings: [DMChattingDBModel]) {
        self.init()
        self.roomID = roomID
        self.user = user
        self.chattings.append(objectsIn: chattings)
    }
}
