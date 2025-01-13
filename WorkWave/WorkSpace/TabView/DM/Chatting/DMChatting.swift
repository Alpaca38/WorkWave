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
        
        case sendMessage
        case connectSocket
        case updateSocketManager(SocketIOManager<DMResponse>?)
        case chattingResponse([Chatting])
    }
    
    @Dependency(\.dmClient) var dmsClient
    @Dependency(\.userClient) var userClient
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
                    // socket 연결
                    if state.socketManager == nil {
                        await send(.connectSocket)
                    }
                    // dbroom 확인
                    
                    // 채팅 추가
                    do {
                        let updateChats = try await fetchAndSaveNewChats(dmsRoomInfo: state.dmRoom)
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
            case .sendButtonTapped:
                return .run { [state = state] send in
                    do {
                        let dataList = state.selectedImages?.compactMap {
                            $0.jpegData(compressionQuality: 0.5)
                        }
                        _ = try await dmsClient.sendMessage(
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
                        case .success(let data):
                            // DB 저장
                            
                            // 업데이트된 채팅 불러오기
                            let updatedChats = try await fetchAndSaveNewChats(dmsRoomInfo: state.dmRoom)
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
    func fetchAndSaveNewChats(
        dmsRoomInfo: DMRoom
    ) async throws -> [Chatting] {
        // db에서 채팅 조회
        
        // 마지막 날짜 이후 채팅 불러오기
        let newDMsChats = try await dmsClient.fetchDMHistory(
            UserDefaultsManager.workspaceID,
            dmsRoomInfo.id,
            "" // last date
        )
        
        // 불러온 채팅 DB에 저장
        
        return newDMsChats.map { $0.toPresentModel() }
    }
}
