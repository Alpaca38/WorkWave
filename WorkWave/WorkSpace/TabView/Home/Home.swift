//
//  Home.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Home {
    @ObservableState
    struct State {
        var isChannelExpanded = true
        var isDMExpanded = true
        
        var isListPresented = false
        
        var currentWorkspace: WorkspaceDTO.ResponseElement?
        var myProfile: MyProfileResponse?
        
        var DMRooms: IdentifiedArrayOf<DMRoom> = [
            DMRoom(room_id: "1", createdAt: "1", user: UserDTO(user_id: "1", email: "", nickname: "캠퍼스지킴이", profileImage: "/static/profiles/1701706651161.jpeg")),
            DMRoom(room_id: "2", createdAt: "2", user: UserDTO(user_id: "2", email: "", nickname: "Hue", profileImage: "/static/profiles/1701706651161.jpeg"))
        ] // dummy
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case workspaceListTapped
        case closeWorkspaceList
        case task
        
        case myWorkspaceResponse(WorkspaceDTO.ResponseElement?)
        case myProfileResponse(MyProfileResponse)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .workspaceListTapped:
                state.isListPresented = true
                return .none
            case .closeWorkspaceList:
                state.isListPresented = false
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
                    } catch {
                        print(error)
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

private extension Home {
    func fetchInitialData() async throws -> (
        workspaceList: WorkspaceDTO.Response,
        profile: MyProfileResponse
    ) {
        // 내가 속한 워크스페이스 리스트 조회
        async let workspaces = workspaceClient.getWorkspaceList()
        // 내 프로필 조회
        async let profile = userClient.fetchMyProfile()
        return try await (workspaces, profile)
    }
}
