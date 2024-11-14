//
//  LoginView.swift
//  WorkWave
//
//  Created by 조규연 on 11/13/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Bindable var store: StoreOf<Login>
    @FocusState var focusedField: Login.State.Field?
    
    var body: some View {
        VStack {
            SheetHeaderView(text: "이메일 로그인") {
                store.send(.exitButtonTapped)
            }
            
            loginView
            
            Spacer()
            
            CustomButton(title: "로그인", font: .title2, titleColor: .white, tintColor: store.loginButtonValid ? .brandGreen : .inactive) {
                store.send(.loginButtonTapped)
            }
            .padding()
            
        }
        .background(.primaryBackground)
        
    }
    
    var loginView: some View {
        VStack(spacing: 8) {
            CustomTextField(title: "이메일", placeholder: "이메일을 입력해주세요.", text: $store.email)
                .focused($focusedField, equals: .email)
            
            CustomTextField(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", text: $store.password)
                .focused($focusedField, equals: .password)
        }
    }
}
