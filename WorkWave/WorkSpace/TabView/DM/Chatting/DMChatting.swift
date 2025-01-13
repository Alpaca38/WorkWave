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
        var message: [Chatting]
        
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
    }
    
    @Dependency(\.dmClient) var dmsClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .task:
                return .none
            case .sendButtonTapped:
                return .none
            case .imageDeleteButtonTapped(let image):
                return .none
            case .backButtonTapped:
                return .none
            }
        }
    }
}
