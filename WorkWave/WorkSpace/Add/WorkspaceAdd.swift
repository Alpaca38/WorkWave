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
        var toast: ToastState = ToastState(toastMessage: "", isToastPresented: false)
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
                state.completeButtonValid = !state.workspaceName.isEmpty
                return .none
            case .exitButtonTapped:
                return .none
            case .imageTapped:
                return .none
            case .completeButtonTapped:
                if state.workspaceName.count > 30 {
                    state.toast = ToastState(toastMessage: "워크스페이스 이름은 1~30자로 설정해주세요.", isToastPresented: true)
                }
                return .none
            }
        }
    }
}
