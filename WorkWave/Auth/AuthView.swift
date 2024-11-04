//
//  AuthView.swift
//  WorkWave
//
//  Created by 조규연 on 11/4/24.
//

import SwiftUI
import ComposableArchitecture

struct AuthView: View {
    @Bindable var store: StoreOf<Auth>
    
    var body: some View {
        VStack {
            CustomButton(image: Image(.logoSIWALeftAlignedWhiteMedium), title: "Apple로 계속하기", font: .title2, titleColor: .white, tintColor: .black) {
                // Apple 로그인
            }
            
            CustomButton(image: Image(.kakao), title: "카카오톡으로 계속하기", font: .title2, titleColor: .black, tintColor: .kakao) {
                // Kakao 로그인
            }
            
            CustomButton(image: Image(.email), title: "이메일로 계속하기", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                // email 로그인
            }
            
            signupView
        }
        .padding()
        .padding(.top, 24)
        .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
            if let store = store.scope(state: \.optionalSignup, action: \.optionalSignup) {
                SignUpView(store: store)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    var signupView: some View {
        Button(action: { store.send(.setSheet(isPresented: true)) }) {
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
