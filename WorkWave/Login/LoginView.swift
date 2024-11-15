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
            .disabled(!store.loginButtonValid)
            
        }
        .background(.primaryBackground)
        .bind($store.focusedField, to: $focusedField)
        .toast(message: store.toast.toastMessage, isPresented: $store.toast.isToastPresented)
        .fullScreenCover(isPresented: $store.isWorkInitSheetPresented.sending(\.setSheet), content: {
            if let store = store.scope(state: \.optionalWorkInit, action: \.optionalWorkInit) {
                WorkspaceInitialView(store: store)
                    .presentationDetents([.large])
            }
        })
    }
    
    var loginView: some View {
        VStack(spacing: 8) {
            CustomTextField(title: "이메일", placeholder: "이메일을 입력해주세요.", text: $store.email)
                .focused($focusedField, equals: .email)
                .foregroundStyle(store.invalidFieldTitles.contains("이메일") ? .red : .black)
            
            CustomTextField(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", text: $store.password)
                .focused($focusedField, equals: .password)
                .foregroundStyle(store.invalidFieldTitles.contains("비밀번호") ? .red : .black)
        }
    }
}
