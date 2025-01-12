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
        
        var isInviteSheetPresented = false
        
        var currentWorkspace: WorkspaceDTO.ResponseElement?
        var myProfile: MyProfileResponse?
        
        var DMRooms: DMRooms = []
        var email: String = ""
        var toast = ToastState(toastMessage: "")
        
        var inviteButtonValid = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case workspaceListTapped
        case closeWorkspaceList
        case inviteMemberSheetButtonTapped
        case inviteMemberButtonTapped
        case inviteExitButtonTapped
        
        case task
        
        case myWorkspaceResponse(WorkspaceDTO.ResponseElement?)
        case myProfileResponse(MyProfileResponse)
        case inviteMemberResponse(Member)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.email):
                state.inviteButtonValid = !state.email.isEmpty
                return .none
            case .binding:
                return .none
            case .workspaceListTapped:
                state.isListPresented = true
                return .none
            case .closeWorkspaceList:
                state.isListPresented = false
                return .none
            case .inviteMemberSheetButtonTapped:
                if state.currentWorkspace?.ownerID == state.myProfile?.userID {
                    state.isInviteSheetPresented = true
                } else {
                    state.toast = ToastState(toastMessage: "초대 권한이 없습니다.", isToastPresented: true)
                }
                return .none
            case .inviteMemberButtonTapped:
                guard let workspaceID = state.currentWorkspace?.workspaceID else {
                    print("현재 워크스페이스가 없습니다.")
                    return .none
                }
                return .run { [email = state.email] send in
                    do {
                        let result = try await workspaceClient.inviteMember(workspaceID, InviteMemberRequest(email: email))
                        await send(.inviteMemberResponse(result.toPresentModel()))
                    } catch {
                        print("초대에 실패했습니다.")
                    }
                }
            case .inviteExitButtonTapped:
                state.isInviteSheetPresented = false
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
            case .inviteMemberResponse(let member):
                state.isInviteSheetPresented = false
                state.toast = ToastState(toastMessage: "팀원 초대에 성공했습니다.", isToastPresented: true)
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
