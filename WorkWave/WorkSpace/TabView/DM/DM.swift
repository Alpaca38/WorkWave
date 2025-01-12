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
        var isLoading = true
        var inviteButtonValid = false
        
        var currentWorkspace: WorkspaceDTO.ResponseElement?
        var myProfile: MyProfileResponse?
        
        var workspaceMembers: [Member] = []
        var dmRooms: DMRooms = []
        
        var isInviteSheetPresented = false
        var email = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case task
        case inviteMemberSheetButtonTapped
        case inviteMemberButtonTapped
        case inviteExitButtonTapped
        
        case myProfileResponse(MyProfileResponse)
        case myWorkspaceResponse(WorkspaceDTO.ResponseElement?)
        
        case workspaceMemeberResponse([Member])
        case dmRoomsResponse(DMRooms)
        case inviteMemberResponse(Member)
        
        case loadingComplete
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.dmClient) var dmClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.email):
                state.inviteButtonValid = !state.email.isEmpty
                return .none
            case .binding:
                return .none
            case .task:
                state.isLoading = true
                return .run { send in
                    do {
                        // workspace, profile 조회
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
                        let (memberResult, dmRoomResult) = try await fetchWorkspaceDetails(
                            workspaceID: UserDefaultsManager.workspaceID
                        )
                        await send(.workspaceMemeberResponse(memberResult))
                        await send(.dmRoomsResponse(dmRoomResult))
                        await send(.loadingComplete)
                    } catch {
                        // 에러 처리
                    }
                }
            case .inviteMemberSheetButtonTapped:
                if state.currentWorkspace?.ownerID == state.myProfile?.userID {
                    state.isInviteSheetPresented = true
                } else {
                    print("초대 권한이 없습니다.")
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
            case .myWorkspaceResponse(let workspace):
                state.currentWorkspace = workspace
                return .none
            case .myProfileResponse(let profile):
                state.myProfile = profile
                return .none
            case .workspaceMemeberResponse(let members):
                let filteredMembers = members.filter { $0.id != UserDefaultsManager.user.userID }
                                state.workspaceMembers = filteredMembers
                state.workspaceMembers = filteredMembers
                return .none
            case .dmRoomsResponse(let dmRooms):
                state.dmRooms = dmRooms
                return .none
            case .inviteMemberResponse(let inviteMember):
                state.workspaceMembers.append(inviteMember)
                state.isInviteSheetPresented = false
                return .none
            case .loadingComplete:
                state.isLoading = false
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
    
    private func fetchWorkspaceDetails(
        workspaceID: String
    ) async throws -> ([Member], [DMRoom]) {
        async let members = workspaceClient.fetchMembers(workspaceID)
        async let dmRooms = dmClient.fetchDMRooms(workspaceID)
        return try await (members.map { $0.toPresentModel() }, dmRooms.map { $0.toPresentModel() })
    }
}
