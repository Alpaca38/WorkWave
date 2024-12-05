//
//  WorkspaceClient.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct WorkspaceClient {
    var networkManager: NetworkManager
    var getWorkspaceList: @Sendable () async throws -> WorkspaceDTO
    var addWorkspace: @Sendable (AddWorkspaceRequest) async throws -> WorkspaceDTO
}

extension WorkspaceClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        getWorkspaceList: { [networkManager = DefaultNetworkManager.shared] in
            do {
                return try await networkManager.fetch(api: WorkspaceRouter.checkWorkspaces, responseType: WorkspaceDTO.self)
            } catch let error as ErrorResponse {
                throw error
            }
        },
        addWorkspace: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.upload(api: WorkspaceRouter.createWorkspace, responseType: WorkspaceDTO.self, request: request)
            } catch let error as ErrorResponse {
                throw error
            }
        }
    
    )
}

extension DependencyValues {
    var workspaceClient: WorkspaceClient {
        get { self[WorkspaceClient.self] }
        set { self[WorkspaceClient.self] = newValue }
    }
}
