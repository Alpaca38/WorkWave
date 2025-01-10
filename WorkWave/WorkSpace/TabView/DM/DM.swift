//
//  DM.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DM {
    @ObservableState
    struct State {
        var currentWorkspace: WorkspaceDTO.ResponseElement?
        var myProfile: MyProfileResponse?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case task
        
        case myProfileResponse(MyProfileResponse)
        case myWorkspaceResponse(WorkspaceDTO.ResponseElement?)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .task:
                return .run { send in
                    do {
                        let (workspaceResult, profileResult) = try await fetchInitialData()
                        await send(.myProfileResponse(profileResult))
                        
                        if let filtered = workspaceResult.filter({ $0.workspaceID == UserDefaultsManager.workspaceID
                        }).first {
                            await send(.myWorkspaceResponse(filtered))
                        } else {
                            guard let workspaceID = workspaceResult.first?.workspaceID else {
                                print("현재 워크 스페이스 없음")
                                return
                            }
                            UserDefaultsManager.saveWorkspaceID(workspaceID)
                            await send(.myWorkspaceResponse(workspaceResult.first))
                        }
                        // memeber, dmRoom 조회
                    } catch {
                        // 에러 처리
                    }
                }
            case .myWorkspaceResponse(let workspace):
                state.currentWorkspace = workspace
                return .none
            case .myProfileResponse(let profile):
                state.myProfile = profile
                return .none
            }
        }
    }
}

extension DM {
    private func fetchInitialData() async throws -> (WorkspaceDTO.Response, MyProfileResponse) {
        async let workspaces = workspaceClient.getWorkspaceList()
        async let profile = userClient.fetchMyProfile()
        return try await (workspaces, profile)
    }
}
