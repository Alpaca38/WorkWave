//
//  Login.swift
//  WorkWave
//
//  Created by 조규연 on 11/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Login {
    @ObservableState
    struct State: Equatable {
        var email = ""
        var password = ""
        
        var loginButtonValid = false
        
        var focusedField: Field?
        
        enum Field: Hashable {
            case email, password
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case loginButtonTapped
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .exitButtonTapped:
                return .none
            case .loginButtonTapped:
                return .none
            }
        }
    }
}
