//
//  DBClient.swift
//  WorkWave
//
//  Created by 조규연 on 1/14/25.
//

import Foundation
import ComposableArchitecture
import RealmSwift

@DependencyClient
struct DBClient {
    var printRealm: () -> Void
    
    var createDMChatting: @Sendable (String, DMChattingDBModel) throws -> Void
    var fetchDMRoom: @Sendable (String) throws -> DMRoomDBModel?
    var updateDMRoom: @Sendable (DMRoomDBModel, MemberDBModel) throws -> Void
    
    var update: @Sendable (Object) throws -> Void
    var removeAll: @Sendable () throws -> Void
}

extension DBClient: DependencyKey {
    static let liveValue = Self(
        printRealm: {
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No realmURL")
        },
        createDMChatting: { roomID, object in
            let realm = try Realm()
            
            guard let dmRoom = realm.object(ofType: DMRoomDBModel.self, forPrimaryKey: roomID) else {
                print("No DMRoom")
                return
            }
            
            if let user = object.user {
                try realm.write {
                    realm.add(user, update: .modified) // 중복되면 업데이트
                }
            }
            
            try realm.write {
                dmRoom.chattings.append(object)
            }
        },
        fetchDMRoom: { roomID in
            let realm = try Realm()
            
            return realm.object(ofType: DMRoomDBModel.self, forPrimaryKey: roomID)
        },
        updateDMRoom: { dmRoom, user in
            let realm = try Realm()
            
            try realm.write {
                if let existingMember = realm.object(
                    ofType: MemberDBModel.self,
                    forPrimaryKey: user.userID
                ) {
                    // 이미 존재하면 필요한 필드만 업데이트
                    existingMember.nickname = user.nickname
                    existingMember.profileImage = user.profileImage
                } else {
                    // 존재하지 않으면 추가
                    realm.add(user)
                }
            }
        },
        update: { object in
            let realm = try Realm()
            
            try realm.write {
                realm.add(object, update: .modified)
            }
        },
        removeAll: {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        }
    )
}

extension DependencyValues {
    var dbClient: DBClient {
        get { self[DBClient.self] }
        set { self[DBClient.self] = newValue }
    }
}
