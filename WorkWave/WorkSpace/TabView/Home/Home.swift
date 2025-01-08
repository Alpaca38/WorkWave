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
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
