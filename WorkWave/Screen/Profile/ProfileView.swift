//
//  ProfileView.swift
//  WorkWave
//
//  Created by 조규연 on 1/14/25.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    @Bindable var store: StoreOf<Profile>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            CustomPhotoPicker(selectedImages: $store.selectedImage, maxSelectedCount: 1) {
                if let images = store.selectedImage, let image = images.last {
                    LoadedImage(uiImage: image, urlString: "", size: 250)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    LoadedImage(urlString: store.profileImage, size: 250)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listRowBackground(Color.clear)
            
            if store.profileType == .me {
                Text("프로필사진 초기화")
                    .frame(maxWidth: .infinity)
                    .applyFont(font: .caption)
                    .foregroundStyle(.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.secondaryText, lineWidth: 1)
                    )
                    .asButton {
                        store.send(.deleteProfileImage)
                    }
                    .frame(alignment: .center)
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
            }
            
            Section {
                HStack {
                    Text("닉네임")
                        .applyFont(font: .bodyBold)
                    Spacer()
                    Text(store.nickname)
                        .foregroundStyle(.secondaryText)
                        .applyFont(font: .bodyRegular)
                    if store.profileType == .me {
                        Image(.chevronRight)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                .foregroundStyle(.black)
                .asButton {
                    store.send(.nicknameTapped)
                }
                .disabled(store.profileType == .otherUser)
                
                if store.profileType == .me {
                    Button {
                        store.send(.phoneNumberTapped)
                    } label: {
                        HStack {
                            Text("연락처")
                                .applyFont(font: .bodyBold)
                            Spacer()
                            Text(store.phoneNumber)
                                .applyFont(font: .bodyRegular)
                                .foregroundStyle(.secondaryText)
                            Image(.chevronRight)
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                    }
                    .foregroundStyle(.black)
                }
                
                HStack {
                    Text("이메일")
                        .applyFont(font: .bodyBold)
                    Spacer()
                    Text(store.email)
                        .foregroundStyle(.secondaryText)
                        .applyFont(font: .bodyRegular)
                }
            }
            
            if store.profileType == .me {
                Section {
                    Button("로그아웃", role: .destructive) {
                        store.send(.logoutButtonTapped)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarBackButtonHidden()
        .customToolbar(
            title: store.profileType == .me ? "내 정보 수정" : "프로필",
            leftItem: .init(icon: .chevronLeft) {
                store.send(.saveButtonTapped)
                dismiss()
            },
            rightItem: store.profileType == .me ?
                .init(text: "저장", isAbled: !store.isProfileChanged) {
                    store.send(.saveButtonTapped)
                    dismiss()
                } : nil
        )
        .customAlert(
            isPresented: $store.isLogoutAlertPresented,
            title: "로그아웃",
            message: "정말 로그아웃 할까요?",
            onConfirm: {
                store.send(.confirmLogout)
            }, onCancel: {
                store.send(.cancelLogout)
            })
        .navigationDestination(isPresented: $store.isEditNicknamePresented) {
            editNicknameView()
        }
    }
}

private extension ProfileView {
    func editNicknameView() -> some View {
        VStack {
            ScrollView {
                CustomTextField(title: "닉네임", placeholder: "닉네임을 입력하세요.", text: $store.nickname)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomButton(title: "완료", font: .title2, titleColor: .white, tintColor: store.editNicknameButtonValid ? .brandGreen : .inactive) {
                store.send(.editNicknameButtonTapped)
                dismiss()
            }
            .padding()
            .disabled(!store.editNicknameButtonValid)
        }
        .background(.primaryBackground)
        .navigationBarBackButtonHidden()
        .customToolbar(
            title: "닉네임",
            leftItem: .init(icon: .chevronLeft) {
                store.send(.editNicknameBackButtonTapped)
            }
        )
    }
}
