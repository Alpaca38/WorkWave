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
    var fetchDMRooms: @Sendable (String) async throws -> [DMRoomResponse]
    var createDMRoom: @Sendable (String, CreateDMRoomRequest) async throws -> DMRoomResponse
    var fetchDMHistory: @Sendable (String, String, String) async throws -> [DMResponse]
    var fetchUnreadDMCount: @Sendable (String, String, String) async throws -> UnreadDMsResponse
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
        },
        createDMRoom: { [networkManager = DefaultNetworkManager.shared] workspaceID, body in
            do {
                return try await networkManager.request(api: DMRouter.createDMRoom(workspaceID: workspaceID, body: body))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        fetchDMHistory: { [networkManager = DefaultNetworkManager.shared] workspaceID, roomID, cursorDate in
            do {
                return try await networkManager.request(api: DMRouter.fetchDMHistory(workspaceID: workspaceID, roomID: roomID, cursorDate: cursorDate))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        fetchUnreadDMCount: { [networkManager = DefaultNetworkManager.shared] workspaceID, roomID, after in
            do {
                return try await networkManager.request(api: DMRouter.fetchUnreadDMCount(workspaceID: workspaceID, roomID: roomID, after: after))
            } catch let error as ErrorResponse {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var dmClient: DMClient {
        get { self[DMClient.self] }
        set { self[DMClient.self] = newValue }
    }
}
