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
        
        var DMRooms: IdentifiedArrayOf<DMRoom> = [
            DMRoom(room_id: "1", createdAt: "1", user: UserDTO(user_id: "1", email: "", nickname: "캠퍼스지킴이", profileImage: "/static/profiles/1701706651161.jpeg")),
            DMRoom(room_id: "2", createdAt: "2", user: UserDTO(user_id: "2", email: "", nickname: "Hue", profileImage: "/static/profiles/1701706651161.jpeg"))
        ] // dummy
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case workspaceListTapped
        case closeWorkspaceList
    }
    
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
            }
        }
    }
}
