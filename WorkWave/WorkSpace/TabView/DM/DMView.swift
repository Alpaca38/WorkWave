//
//  DMView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct DMView: View {
    @Bindable var store: StoreOf<DM>
    
    var body: some View {
        VStack {
            if store.isLoading {
                ProgressView()
            } else if store.workspaceMembers.isEmpty {
                emptyMemeberView()
                    .padding()
            } else {
                HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", profileImage: store.myProfile?.profileImage ?? "", size: 32, title: "Direct Message")
                    .padding()
                
                Divider()
                
                ScrollView(.horizontal) {
                    
                }
                
                Divider()
                
                ScrollView {
                    
                }
                
                Spacer()
            }
        }
        .task {
            store.send(.task)
        }
        .sheet(isPresented: $store.isInviteSheetPresented) {
            inviteMemberView()
                .presentationDragIndicator(.visible)
        }
    }
}

private extension DMView {
    func emptyMemeberView() -> some View {
        VStack(spacing: 8) {
            HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", profileImage: store.myProfile?.profileImage ?? "", size: 32, title: "Direct Message")
            
            Divider()
            
            Spacer()
            
            Text("워크스페이스에 멤버가 없어요.")
                .applyFont(font: .title1)
            Text("새로운 팀원을 초대해보세요.")
                .applyFont(font: .bodyRegular)
            CustomButton(title: "팀원 초대하기", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                store.send(.inviteMemberSheetButtonTapped)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    func inviteMemberView() -> some View {
        VStack {
            SheetHeaderView(text: "팀원 초대") {
                store.send(.inviteExitButtonTapped)
            }
            ScrollView {
                CustomTextField(title: "이메일", placeholder: "초대하려는 팀원의 이메일을 입력하세요.", text: $store.email)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomButton(title: "초대 보내기", font: .title2, titleColor: .white, tintColor: store.inviteButtonValid ? .brandGreen : .inactive) {
                store.send(.inviteMemberButtonTapped)
            }
            .padding()
            .disabled(!store.inviteButtonValid)
        }
        .background(.primaryBackground)
    }
}
