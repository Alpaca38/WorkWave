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
        
        var workspaces: WorkspaceDTO.Response = []
        
        var isAddWorkspacePresented: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addWorkspaceTapped
        case fetchWorkspaces
        
        case workspaceResponse(WorkspaceDTO.Response)
        
        case workspaceAdd(WorkspaceAdd.Action)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .fetchWorkspaces:
                // 서버에서 워크스페이스 목록 불러오기
                return .run { send in
                    do {
                        await send(.workspaceResponse(try await workspaceClient.getWorkspaceList()))
                    } catch {
                        print(error)
                    }
                }
            case .addWorkspaceTapped:
                state.workspaceAdd = WorkspaceAdd.State()
                state.isAddWorkspacePresented = true
                return .none
                
            case .binding:
                return .none
                
            case .workspaceResponse(let workspaces):
                state.workspaces = workspaces
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
