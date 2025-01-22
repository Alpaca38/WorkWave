//
//  DMChatting.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DMChatting {
    @ObservableState
    struct State {
        var socketManager: SocketIOManager<DMResponse>?
        
        var dmRoom: DMRoom
        var message: [Chatting] = []
        
        var messageText = ""
        var selectedImages: [UIImage]? = []
        var scrollViewID = UUID()
        
        var messageButtonValid = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case task
        case active
        case background
        
        case sendButtonTapped
        case imageDeleteButtonTapped(UIImage)
        case backButtonTapped
        case profileImageTapped(Member)
        
        case sendMessage
        case connectSocket
        case updateSocketManager(SocketIOManager<DMResponse>?)
        case chattingResponse([Chatting])
    }
    
    @Dependency(\.dmClient) var dmClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.dbClient) var dbClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.messageText):
                state.messageButtonValid = !state.messageText.isEmpty
                || !(state.selectedImages?.isEmpty ?? true)
                return .none
                
            case .binding(\.selectedImages):
                state.messageButtonValid = !(state.selectedImages?.isEmpty ?? true)
                return .none
                
            case .binding:
                return .none
            case .task:
                return .run { [state = state] send in
                    dbClient.printRealm()
                    // socket 연결
                    if state.socketManager == nil {
                        await send(.connectSocket)
                    }
                    // dbroom 저장
                    await saveOrUpdateDMRoom(room: state.dmRoom)
                    // 채팅 추가
                    do {
                        let updateChats = try await fetchAndSaveNewChats(room: state.dmRoom)
                        await send(.chattingResponse(updateChats))
                    } catch {
                        print("채팅 불러오기 실패", error)
                    }
                }
            case .active:
                return .run { [state = state] send in
                    if state.socketManager == nil {
                        await send(.connectSocket)
                    }
                }
            case .background:
                state.socketManager = nil
                return .none
                
            case .profileImageTapped:
                return .none
            case .sendButtonTapped:
                return .run { [state = state] send in
                    do {
                        let dataList = state.selectedImages?.compactMap {
                            $0.jpegData(compressionQuality: 0.5)
                        }
                        _ = try await dmClient.sendMessage(
                            UserDefaultsManager.workspaceID,
                            state.dmRoom.id,
                            DMRequest(
                                content: state.messageText,
                                files: dataList ?? []
                            )
                        )
                        await send(.sendMessage)
                    } catch {
                        print("메세지 전송 실패")
                    }
                }
            case .sendMessage:
                state.messageText = ""
                state.selectedImages = []
                state.messageButtonValid = false
                return .none
            case .connectSocket:
                return .run { [state = state] send in
                    let socketManager = SocketIOManager<DMResponse>(id: state.dmRoom.id, socketInfo: .dm)
                    
                    await send(.updateSocketManager(socketManager))
                    
                    // 소켓 이벤트를 비동기적으로 처리
                    for try await result in socketManager {
                        switch result {
                        case .success(_):
                            // 업데이트된 채팅 저장 후 불러오기
                            let updatedChats = try await fetchAndSaveNewChats(room: state.dmRoom)
                            // 상태 업데이트 액션 전송
                            await send(.chattingResponse(updatedChats))
                        case .failure(let error):
                            print("소켓 데이터 받기 실패: \(error)")
                        }
                    }
                }
            case .updateSocketManager(let manager):
                state.socketManager = manager
                return .none
            case .chattingResponse(let chattings):
                state.message = chattings
                return .none
            case .imageDeleteButtonTapped(let image):
                guard let index = state.selectedImages?.firstIndex(of: image) else {
                    return .none
                }
                state.selectedImages?.remove(at: index)
                return .none
            case .backButtonTapped:
                return .run { send in
                    await send(.updateSocketManager(nil))
                    await dismiss()
                }
            }
        }
    }
}

private extension DMChatting {
    func fetchMember(room: DMRoom) async -> MemberDBModel {
        do {
            return try await userClient.fetchOthersProfile(room.user.id).toDBModel()
        } catch {
            print("db profile fetching error")
            return MemberDBModel()
        }
    }
    
    func updateMemberProfile(userID: String) async {
        do {
            let currentProfile = try await userClient.fetchOthersProfile(userID)
            let dbProfile = try dbClient.fetchMember(userID)
            
            // db에 프로필 이미지가 없는 경우
            guard let dbProfileImage = dbProfile?.profileImage else {
                guard let currentProfileImage = currentProfile.profileImage else {
                    return
                }
                
                await ImageFileManager.shared.saveImage(fileName: currentProfileImage)
                return
            }
            
            // 현재 프로필과 db 프로필이 다른 경우
            if dbProfileImage != currentProfile.profileImage {
                ImageFileManager.shared.deleteImage(fileName: dbProfileImage)
                guard let currentProfileImage = currentProfile.profileImage else {
                    return
                }
                
                await ImageFileManager.shared.saveImage(fileName: currentProfileImage)
                
                // 현재 프로필로 db 업데이트
                try dbClient.update(currentProfile.toDBModel())
            }
        } catch {
            print("프로필 불러오기 실패")
        }
    }
    
    func saveOrUpdateDMRoom(room: DMRoom) async {
        let member = await fetchMember(room: room)
        
        await updateMemberProfile(userID: room.user.id)
        
        do {
            if let dbRoom = try dbClient.fetchDMRoom(room.id) {
                do {
                    try dbClient.updateDMRoom(dbRoom, member)
                    print("DMRoom 업데이트 성공")
                } catch {
                    print("DMRoom 업데이트 실패")
                }
            } else {
                do {
                    try dbClient.update(room.toDBModel(user: member))
                    print("DMRoom 저장")
                } catch {
                    print("DMRoom 저장 실패")
                }
            }
        } catch {
            print("DMRoom 저장/업데이트 실패")
        }
    }
    
    func fetchDBChat(room: DMRoom) async -> [DMChattingDBModel] {
        do {
            guard let dbRoom = try dbClient.fetchDMRoom(room.id) else {
                print("저장된 DMRoom이 없습니다.")
                return []
            }
            return Array(dbRoom.chattings.sorted(byKeyPath: "createdAt"))
        } catch {
            print("채팅 불러오기 실패")
            return []
        }
    }
    
    func saveChat(chat: DMResponse, room: DMRoom) async {
        do {
            try dbClient.createDMChatting(room.id, chat.toDBModel(chat.user.toDBModel()))
            print("채팅 저장 성공")
        } catch {
            print("채팅 저장 실패")
        }
        
        // 이미지 저장
        for file in chat.files {
            await ImageFileManager.shared.saveImage(fileName: file)
        }
    }
    
    func fetchAndSaveNewChats(
        room: DMRoom
    ) async throws -> [Chatting] {
        // db에서 채팅 조회
        let dbChat = await fetchDBChat(room: room)
        
        // 마지막 날짜 이후 채팅 조회
        let newChat = try await dmClient.fetchDMHistory(UserDefaultsManager.workspaceID, room.id, dbChat.last?.createdAt ?? "")
        
        // 불러온 채팅 DB에 저장
        await withTaskGroup(of: Void.self) { group in
            for chat in newChat {
                group.addTask {
                    await saveChat(chat: chat, room: room)
                }
            }
        }
        
        // 총 채팅 내역 조회
        return await fetchDBChat(room: room).map { $0.toPresentModel() }
    }
}
