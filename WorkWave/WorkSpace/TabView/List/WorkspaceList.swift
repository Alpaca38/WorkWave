//
//  WorkspaceList.swift
//  WorkWave
//
//  Created by 조규연 on 12/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkspaceList {
    @ObservableState
    struct State: Equatable {
        var workspaceAdd: WorkspaceAdd.State?
        
        var workspaces: IdentifiedArrayOf<WorkspaceDTO.ResponseElement> = []
        
        var isAddWorkspacePresented: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addWorkspaceTapped
        case fetchWorkspaces
        
        case workspaceAdd(WorkspaceAdd.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .fetchWorkspaces:
                // 서버에서 워크스페이스 목록 불러오기
                state.workspaces = []
                return .none
                
            case .addWorkspaceTapped:
                state.workspaceAdd = WorkspaceAdd.State()
                state.isAddWorkspacePresented = true
                return .none
                
            case .binding:
                return .none
                
            case .workspaceAdd(.exitButtonTapped):
                state.workspaceAdd = nil
                state.isAddWorkspacePresented = false
                return .none
                
            case .workspaceAdd:
                return .none
            }
        }
        .ifLet(\.workspaceAdd, action: \.workspaceAdd) {
            WorkspaceAdd()
        }
    }
}
