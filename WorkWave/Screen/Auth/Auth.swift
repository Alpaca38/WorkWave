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
        
        var appleLoginSuccess = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case optionalSignup(SignUp.Action)
        case optionalLogin(Login.Action)
        case setSignUpSheet(isPresented: Bool)
        case setLoginSheet(isPresented: Bool)
        
        case appleLoginButtonTapped(AppleLoginRequest)
        
        case appleLoginSuccess
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.jwtKeyChain) var jwtKeyChain
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
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
            case .appleLoginButtonTapped(let request):
                return .run { send in
                    do {
                        let result = try await userClient.appleLogin(request)
                        UserDefaultsManager.user = User(userID: result.userID, nickname: result.nickname, email: result.email, phoneNumber: result.phone)
                        jwtKeyChain.handleLoginSuccess(accessToken: result.token.accessToken, refreshToken: result.token.refreshToken)
                        await send(.appleLoginSuccess)
                    } catch {
                        print(error)
                    }
                }
            case .appleLoginSuccess:
                state.appleLoginSuccess = true
                return .none
            }
        }
        .ifLet(\.optionalSignup, action: \.optionalSignup) {
            SignUp()
        }
        .ifLet(\.optionalLogin, action: \.optionalLogin) {
            Login()
        }
    }
    
}
