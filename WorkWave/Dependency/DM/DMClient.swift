//
//  DMClient.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct DMClient {
    var networkManager: NetworkManager
    var fetchDMRooms: @Sendable (String) async throws -> [DMResponse]
}

extension DMClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        fetchDMRooms: { [networkManager = DefaultNetworkManager.shared] workspaceID in
            do {
                return try await networkManager.request(api: DMRouter.fetchDMRooms(workspaceID: workspaceID))
            } catch let error as ErrorResponse {
                throw error
            }
        }
    )
}
