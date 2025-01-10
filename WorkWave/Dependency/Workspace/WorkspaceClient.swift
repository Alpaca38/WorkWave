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
    var fetchMembers: @Sendable (String) async throws -> [MemberResponse]
    var inviteMember: @Sendable (String, InviteMemberRequest) async throws -> MemberResponse
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
        },
        fetchMembers: { [networkManager = DefaultNetworkManager.shared] workspaceID in
            do {
                return try await networkManager.request(api: WorkspaceRouter.fetchMembers(workspaceID: workspaceID))
            } catch let error as ErrorResponse {
                throw error
            }
        }
        ,inviteMember: { [networkManager = DefaultNetworkManager.shared] workspaceID, inviteRequest in
            do {
                return try await networkManager.request(api: WorkspaceRouter.inviteMember(workspaceID: workspaceID, body: inviteRequest))
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
