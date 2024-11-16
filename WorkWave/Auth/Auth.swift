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
        var isSingUpSheetPresented = false
        
        var optionalLogin: Login.State?
        var isLoginSheetPresented = false
    }
    
    enum Action {
        case optionalSignup(SignUp.Action)
        case optionalLogin(Login.Action)
        case setSignUpSheet(isPresented: Bool)
        case setLoginSheet(isPresented: Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { 
            case .optionalSignup(.exitButtonTapped):
                state.isSingUpSheetPresented = false
                state.optionalSignup = nil
                return .none
            case .optionalSignup:
                return .none
            case .setSignUpSheet(isPresented: true):
                state.isSingUpSheetPresented = true
                state.optionalSignup = SignUp.State()
                return .none
            case .setSignUpSheet(isPresented: false):
                state.isSingUpSheetPresented = false
                state.optionalSignup = nil
                return .none
            case .optionalLogin(.exitButtonTapped):
                state.isLoginSheetPresented = false
                state.optionalLogin = nil
                return .none
            case .optionalLogin:
                return .none
            case .setLoginSheet(isPresented: true):
                state.isLoginSheetPresented = true
                state.optionalLogin = Login.State()
                return .none
            case .setLoginSheet(isPresented: false):
                state.isLoginSheetPresented = false
                state.optionalLogin = nil
                return .none
            }
        }
        .ifLet(\.optionalSignup, action: \.optionalSignup) {
            SignUp(jwtKeyChain: JWTKeyChain(), deviceTokenKeyChain: DeviceTokenKeyChain())
        }
        .ifLet(\.optionalLogin, action: \.optionalLogin) {
            Login(jwtKeyChain: JWTKeyChain(), deviceTokenKeyChain: DeviceTokenKeyChain())
        }
    }
    
}
