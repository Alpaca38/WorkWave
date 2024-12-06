//
//  WorkSpaceInitial.swift
//  WorkWave
//
//  Created by 조규연 on 11/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkspaceInitial {
    @ObservableState
    struct State: Equatable {
        var workspaceAdd: WorkspaceAdd.State?
        
        var isSheetPresented = false
        var isHomePresented = false
        var isListPresented = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case exitButtonTapped(isPresented: Bool)
        case setSheet(isPresented: Bool)
        case workspaceListTapped
        case closeWorkspaceList
        
        case workspaceAdd(WorkspaceAdd.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action { 
            case .binding:
                return .none
            case .exitButtonTapped(isPresented: true):
                UserDefaultsManager.isSignedUp = true
                state.isHomePresented = true
                return .none
            case .exitButtonTapped(isPresented: false):
                state.isHomePresented = false
                return .none
            case .setSheet(isPresented: true):
                state.workspaceAdd = WorkspaceAdd.State()
                state.isSheetPresented = true
                return .none
            case .setSheet(isPresented: false):
                state.workspaceAdd = nil
                state.isSheetPresented = false
                return .none
            case .workspaceListTapped:
                state.isListPresented = true
                return .none
            case .closeWorkspaceList:
                state.isListPresented = false
                return .none
            case .workspaceAdd(.exitButtonTapped):
                state.workspaceAdd = nil
                state.isSheetPresented = false
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
