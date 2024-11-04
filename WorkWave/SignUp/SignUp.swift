//
//  SignUp.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUp {
    @ObservableState
    struct State: Equatable {
        var email = ""
        var nickname = ""
        var phone = ""
        var password = ""
        var comfirmPassword = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case signupButtonTapped
        case emailCheckButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .exitButtonTapped:
                return .none
            case .signupButtonTapped:
                return .none
            case .emailCheckButtonTapped:
                return .none
            }
        }
    }
}
