//
//  Auth.swift
//  WorkWave
//
//  Created by 조규연 on 11/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Auth {
    @ObservableState
    struct State: Equatable {
        var optionalSignup: SignUp.State?
        var isSheetPresented = false
    }
    
    enum Action {
        case optionalSignup(SignUp.Action)
        case setSheet(isPresented: Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { 
            case .optionalSignup(.exitButtonTapped):
                state.isSheetPresented = false
                state.optionalSignup = nil
                return .none
            case .optionalSignup:
                return .none
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                state.optionalSignup = SignUp.State()
                return .none
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                state.optionalSignup = nil
                return .none
            }
        }
        .ifLet(\.optionalSignup, action: \.optionalSignup) {
            SignUp(jwtKeyChain: JWTKeyChain(), deviceTokenKeyChain: DeviceTokenKeyChain())
        }
    }
    
}
