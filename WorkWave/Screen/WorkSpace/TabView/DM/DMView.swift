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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                if store.isLoading {
                    ProgressView()
                } else if store.workspaceMembers.isEmpty {
                    emptyMemeberView()
                        .padding()
                } else {
                    HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", myProfile: store.myProfile, size: 32, title: "Direct Message")
                        .padding()
                    
                    Divider()
                    
                    memberListView()
                    
                    Divider()
                    
                    chatListView()
                    
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
        } destination: { store in
            switch store.case {
            case .dmChatting(let store):
                DMChattingView(store: store)
            }
        }
    }
}

private extension DMView {
    func emptyMemeberView() -> some View {
        VStack(spacing: 8) {
            HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", myProfile: store.myProfile, size: 32, title: "Direct Message")
            
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
    
    func memberListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(store.workspaceMembers, id: \.id) { item in
                    userCell(user: item)
                }
            }
            .frame(height: 100)
            .padding(.horizontal, 16)
        }
    }
    
    func userCell(user: Member) -> some View {
        VStack(spacing: 4) {
            LoadedImage(urlString: user.profileImage ?? "", size: 44)
            Text(user.nickname)
                .applyFont(font: .bodyRegular)
                .frame(width: 44)
                .lineLimit(1)
        }
        .asButton {
            store.send(.userCellTapped(user))
        }
        .buttonStyle(.plain)
    }
    
    func chatListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.dmRooms, id: \.id) { dmRoom in
                    let lastChatting = store.dmLastChattings[dmRoom]
                    let unreadResponse = store.dmUnreads[dmRoom]
                    dmCell(
                        dm: dmRoom,
                        lastChatting: lastChatting,
                        unreadCount: unreadResponse
                    )
                }
            }
        }
    }
    
    func dmCell(
        dm: DMRoom,
        lastChatting: Chatting?,
        unreadCount: UnreadDMsResponse?
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            LoadedImage(urlString: dm.user.profileImage ?? "", size: 34)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(dm.user.nickname)
                    .applyFont(font: .bodyRegular)
                
                Text(lastChatting?.text ?? "대화를 시작해보세요")
                    .applyFont(font: .bodyRegular)
                    .foregroundStyle(.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let date = DateManager.shared.toDate(createdAt: lastChatting?.date ?? "") {
                    let dateString = date.isToday ? date.toString(.todayChat) :
                    date.toString(.pastChat)
                    
                    Text(dateString)
                        .applyFont(font: .bodyRegular)
                        .foregroundStyle(.secondaryText)
                    
                    Text("\(unreadCount?.count ?? 0)")
                        .badge()
                        .opacity(unreadCount?.count ?? 0 <= 0 ? 0 : 1)
                }
            }
        }
        .padding(.horizontal, 16)
        .asButton {
            store.send(.dmCellTapped(dm))
        }
        .buttonStyle(.plain)
    }
}
