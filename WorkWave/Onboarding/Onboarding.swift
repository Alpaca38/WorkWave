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
        var optionalSignUp: SignUp.State?
        var isSheetPresented = false
    }
    
    enum Action {
        case optionalSignUp(SignUp.Action)
        case setSheet(isPresented: Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .optionalSignUp(.exitButtonTapped):
                state.isSheetPresented = false
                state.optionalSignUp = nil
                return .none
            case .optionalSignUp:
                return .none
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                state.optionalSignUp = SignUp.State()
                return .none
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                state.optionalSignUp = nil
                return .none
            }
        }
        .ifLet(\.optionalSignUp, action: \.optionalSignUp) {
            SignUp()
        }
    }
}
