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
            ZStack {
                HStack {
                    Image(.close)
                        .asButton {
                            store.send(.exitButtonTapped)
                        }
                    Spacer()
                }
                Text("회원가입")
                    .applyFont(font: .title1)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background(.secondaryBackground)
            
            VStack(spacing: 0) {
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
                            // 중복확인
                        }
                        .frame(width: 100)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                CustomTextField(title: "닉네임", placeholder: "닉네임을 입력하세요", text: $store.nickname)
                CustomTextField(title: "연락처", placeholder: "전화번호를 입력하세요", text: $store.nickname)
                CustomTextField(title: "비밀번호", placeholder: "비밀번호를 입력하세요", text: $store.nickname)
                CustomTextField(title: "비밀번호 확인", placeholder: "비밀번호를 한 번 더 입력하세요", text: $store.nickname)
                
                Spacer()
                
                CustomButton(title: "가입하기", font: .title2, titleColor: .white, tintColor: .inactive) {
                    // 가입하기
                }
                .padding()
            }
            .background(.primaryBackground)
        }
    }
}
