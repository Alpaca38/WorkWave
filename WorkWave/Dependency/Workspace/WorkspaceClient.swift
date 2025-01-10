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
    var getWorkspaceList: @Sendable () async throws -> WorkspaceDTO.Response
    var addWorkspace: @Sendable (AddWorkspaceRequest) async throws -> WorkspaceDTO.ResponseElement
}

extension WorkspaceClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        getWorkspaceList: { [networkManager = DefaultNetworkManager.shared] in
            do {
                return try await networkManager.request(api: WorkspaceRouter.checkWorkspaces)
            } catch let error as ErrorResponse {
                throw error
            }
        },
        addWorkspace: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: WorkspaceRouter.createWorkspace(request))
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
