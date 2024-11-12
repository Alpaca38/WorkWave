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
        var isSheetPresented = false
        var isHomePresented = false
    }
    
    enum Action {
        case exitButtonTapped(isPresented: Bool)
        case setSheet(isPresented: Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { 
            case .exitButtonTapped(isPresented: true):
                UserDefaultsManager.isSignedUp = true
                state.isHomePresented = true
                return .none
            case .exitButtonTapped(isPresented: false):
                state.isHomePresented = false
                return .none
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                return .none
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                return .none
            }
        }
    }
}
