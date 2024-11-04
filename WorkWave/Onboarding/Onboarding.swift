//
//  Onboarding.swift
//  WorkWave
//
//  Created by 조규연 on 11/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Onboarding {
    @ObservableState
    struct State: Equatable {
        var isSheetPresented = false
    }
    
    enum Action {
        case setSheet(isPresented: Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
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
