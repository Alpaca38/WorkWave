//
//  SignUpView.swift
//  WorkWave
//
//  Created by 조규연 on 11/2/24.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    @Bindable var store: StoreOf<SignUp>
    
    var body: some View {
        NavigationStack {
            VStack {
                SheetHeaderView(text: "회원가입") {
                    store.send(.exitButtonTapped)
                }
                
                signupInfoView
                
                Spacer()
                
                CustomButton(title: "가입하기", font: .title2, titleColor: .white, tintColor: .inactive) {
                    store.send(.signupButtonTapped)
                }
                .padding()
            }
            .background(.primaryBackground)
        }
    }
    
    var signupInfoView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                emailTextField
                .padding()
                
                CustomTextField(title: "닉네임", placeholder: "닉네임을 입력하세요", text: $store.nickname)
                CustomTextField(title: "연락처", placeholder: "전화번호를 입력하세요", text: $store.nickname)
                CustomTextField(title: "비밀번호", placeholder: "비밀번호를 입력하세요", text: $store.nickname)
                CustomTextField(title: "비밀번호 확인", placeholder: "비밀번호를 한 번 더 입력하세요", text: $store.nickname)
            }
        }
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("이메일")
                .applyFont(font: .title2)
            HStack {
                TextField("이메일을 입력하세요", text: $store.email)
                    .padding(10) // 텍스트 필드 내부 여백
                    .frame(height: 44)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .applyFont(font: .bodyRegular)
                
                CustomButton(title: "중복 확인", font: .title2, titleColor: .white, tintColor: .inactive) {
                    store.send(.exitButtonTapped)
                }
                .frame(width: 100)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
