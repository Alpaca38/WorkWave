//
//  AuthView.swift
//  WorkWave
//
//  Created by 조규연 on 11/4/24.
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture

struct AuthView: View {
    @Bindable var store: StoreOf<Auth>
    @Dependency(\.deviceKeyChain) var deviceKeyChain
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }) { result in
                switch result {
                case .success(let success):
                    handleAuthorization(authResults: success)
                case .failure(let failure):
                    print("apple 로그인 실패", failure)
                }
            }
            .frame(height: 44)
            
            CustomButton(image: Image(.kakao), title: "카카오톡으로 계속하기", font: .title2, titleColor: .black, tintColor: .kakao) {
                // Kakao 로그인
            }
            
            CustomButton(image: Image(.email), title: "이메일로 계속하기", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                store.send(.setLoginSheet(isPresented: true))
            }
            
            signupView
        }
        .padding()
        .padding(.top, 24)
        .sheet(isPresented: $store.isSingUpSheetPresented.sending(\.setSignUpSheet)) {
            if let store = store.scope(state: \.optionalSignup, action: \.optionalSignup) {
                SignUpView(store: store)
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $store.isLoginSheetPresented.sending(\.setLoginSheet)) {
            if let store = store.scope(state: \.optionalLogin, action: \.optionalLogin) {
                LoginView(store: store)
                    .presentationDragIndicator(.visible)
            }
        }
        .fullScreenCover(isPresented: $store.appleLoginSuccess, content: {
            WorkspaceInitialView(store: Store(initialState: WorkspaceInitial.State()) {
                WorkspaceInitial()
            })
        })
    }
    
    var signupView: some View {
        Button(action: { store.send(.setSignUpSheet(isPresented: true)) }) {
            HStack(spacing: 4) {
                Text("또는")
                    .foregroundStyle(.black)
                Text("새롭게 회원가입하기")
                    .foregroundStyle(.brandGreen)
            }
            .applyFont(font: .title2)
            .frame(height: 44)
        }
    }
}

extension AuthView {
    private func handleAuthorization(authResults: ASAuthorization) {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            
            if let idTokenData = appleIDCredential.identityToken,
               let idToken = String(data: idTokenData, encoding: .utf8),
               let fullName = appleIDCredential.fullName
            {
                let name = (fullName.familyName ?? "") + (fullName.givenName ?? "")
                print("idToken: \(idToken)")
                print("name: \(name)")
                store.send(.appleLoginButtonTapped(AppleLoginRequest(idToken: idToken, nickname: name, deviceToken: deviceKeyChain.deviceToken)))
            } else {
                print("idToken 조회 실패")
            }
        }
    }
}
