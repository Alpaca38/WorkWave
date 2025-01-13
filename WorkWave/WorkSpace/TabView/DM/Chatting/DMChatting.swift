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
        case sendButtonTapped
        case imageDeleteButtonTapped(UIImage)
        case backButtonTapped
        
        case sendMessage
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
            case .imageDeleteButtonTapped(let image):
                guard let index = state.selectedImages?.firstIndex(of: image) else {
                    return .none
                }
                state.selectedImages?.remove(at: index)
                return .none
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
