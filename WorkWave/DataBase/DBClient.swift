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
            
            try realm.write {
                dmRoom.chattings.append(object)
            }
        },
        fetchDMRoom: { roomID in
            let realm = try Realm()
            
            return realm.object(ofType: DMRoomDBModel.self, forPrimaryKey: roomID)
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
