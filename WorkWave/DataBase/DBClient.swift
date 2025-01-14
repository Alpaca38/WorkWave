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
    
}

extension DBClient: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var dbClient: DBClient {
        get { self[DBClient.self] }
        set { self[DBClient.self] = newValue }
    }
}
