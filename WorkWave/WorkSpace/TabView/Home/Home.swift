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
    @Reducer
    enum Path {
        case dmChatting(DMChatting)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var isChannelExpanded = true
        var isDMExpanded = true
        
        var isListPresented = false
        
        var isInviteSheetPresented = false
        
        var currentWorkspace: WorkspaceDTO.ResponseElement?
        var myProfile: MyProfileResponse?
        
        var DMRooms: DMRooms = []
        var email: String = ""
        var toast = ToastState(toastMessage: "")
        
        var dmUnreads = [DMRoom: UnreadDMsResponse]()
        
        var inviteButtonValid = false
    }
    
    enum Action: BindableAction {
        case path(StackActionOf<Path>)
        case binding(BindingAction<State>)
        
        case workspaceListTapped
        case closeWorkspaceList
        case inviteMemberSheetButtonTapped
        case inviteMemberButtonTapped
        case inviteExitButtonTapped
        case dmCellTapped(DMRoom)
        
        case task
        
        case myWorkspaceResponse(WorkspaceDTO.ResponseElement?)
        case myProfileResponse(MyProfileResponse)
        case inviteMemberResponse
        case dmRoomsResponse(DMRooms)
        case unreadCountResponse(DMRoom, UnreadDMsResponse)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.dmClient) var dmClient
    @Dependency(\.dbClient) var dbClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
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
                        _ = try await workspaceClient.inviteMember(workspaceID, InviteMemberRequest(email: email))
                        await send(.inviteMemberResponse)
                    } catch {
                        print("초대에 실패했습니다.")
                    }
                }
            case .inviteExitButtonTapped:
                state.isInviteSheetPresented = false
                return .none
            case .dmCellTapped(let dmRoom):
                state.path.append(.dmChatting(DMChatting.State(dmRoom: dmRoom)))
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
                        
                        let dmRoomResult = try await fetchDMRooms(workspaceID: UserDefaultsManager.workspaceID)
                        await send(.dmRoomsResponse(dmRoomResult))
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
            case .inviteMemberResponse:
                state.isInviteSheetPresented = false
                state.toast = ToastState(toastMessage: "팀원 초대에 성공했습니다.", isToastPresented: true)
                return .none
            case .dmRoomsResponse(let dmRooms):
                state.DMRooms = dmRooms
                return .merge(dmRooms.map { dmRoom in
                    return .run { send in
                        if let profileImage = dmRoom.user.profileImage {
                            await ImageFileManager.shared.saveImage(fileName: profileImage)
                        }
                        
                        do {
                            let dbDMRoom = try dbClient.fetchDMRoom(dmRoom.id)
                            let lastDate = dbDMRoom?.chattings.sorted {
                                $0.createdAt < $1.createdAt
                            }.last?.createdAt ?? ""
                            
                            
                            let unreadCount = try await fetchUnreadCount(workspaceID: UserDefaultsManager.workspaceID, roomID: dmRoom.id, lastCreatedAt: lastDate)
                            await send(.unreadCountResponse(dmRoom, unreadCount))
                        } catch {
                            print("Unread Count 조회 실패")
                        }
                    }
                })
            case .unreadCountResponse(let dmRoom, let unreadResponse):
                state.dmUnreads[dmRoom] = unreadResponse
                return .none
            }
        }
        .forEach(\.path, action: \.path)
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
    
    func fetchDMRooms(workspaceID: String) async throws -> DMRooms {
        async let dmRooms = dmClient.fetchDMRooms(workspaceID)
        return try await dmRooms.map { $0.toPresentModel() }
    }
    
    func fetchUnreadCount(workspaceID: String, roomID: String, lastCreatedAt: String) async throws -> UnreadDMsResponse {
        async let unreadCount = dmClient.fetchUnreadDMCount(workspaceID, roomID, lastCreatedAt)
        return try await unreadCount
    }
}
