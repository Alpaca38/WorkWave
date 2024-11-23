//
//  WorkspaceAdd.swift
//  WorkWave
//
//  Created by 조규연 on 11/12/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkspaceAdd {
    @ObservableState
    struct State: Equatable {
        var workspaceName = ""
        var workspaceDescription = ""
        var completeButtonValid = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case imageTapped
        case completeButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .exitButtonTapped:
                return .none
            case .imageTapped:
                return .none
            case .completeButtonTapped:
                return .none
            }
        }
    }
}
