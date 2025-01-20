//
//  HomeView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<Home>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                defaultView
                    .gesture(
                        DragGesture()
                            .onEnded({ value in
                                if value.translation.width > 100 {
                                    store.send(.workspaceListTapped, animation: .easeInOut)
                                }
                            })
                    )
                
                if store.isListPresented {
                    SideView {
                        store.send(.closeWorkspaceList, animation: .easeInOut)
                    }
                }
            }
            .task {
                store.send(.task)
            }
            .sheet(isPresented: $store.isInviteSheetPresented) {
                inviteMemberView()
                    .presentationDragIndicator(.visible)
            }
            .toast(message: store.toast.toastMessage, isPresented: $store.toast.isToastPresented)
        } destination: { store in
            switch store.case {
            case .dmChatting(let store):
                DMChattingView(store: store)
            }
        }
        
    }
    
    var defaultView: some View {
        VStack {
            HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", myProfile: store.myProfile, size: 32, title: store.currentWorkspace?.name ?? "")
                .padding(.horizontal)
                .onTapGesture {
                    store.send(.workspaceListTapped, animation: .easeInOut)
                }
            
            Divider()
            
            CustomFoldingGroup(label: "채널", isExpanded: $store.isChannelExpanded) {
                ChannelListView()
                makeAddButton(text: "채널 추가") {
                    // addChannel
                }
            }
            .foregroundStyle(.black)
            .padding()
            
            Divider()
            
            CustomFoldingGroup(label: "다이렉트 메세지", isExpanded: $store.isDMExpanded) {
                DMListView
                makeAddButton(text: "새 메세지 추가") {
                    // addDM
                }
            }
            .foregroundStyle(.black)
            .padding()
            
            Divider()
            
            makeAddButton(text: "팀원 추가") {
                store.send(.inviteMemberSheetButtonTapped)
            }
            .padding()
            
            Spacer()
            
        }
    }
}

private extension HomeView {
    struct ChannelListView: View {
        let tags: [String] = ["일반", "스유 뽀개기", "앱스토어 홍보", "오픈 라운지"] // dummy
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    HStack(spacing: 8) {
                        Text("#")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text(tag)
                            .applyFont(font: .bodyRegular)
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .foregroundStyle(.secondaryText)
                }
            }
        }
    }
    
    var DMListView: some View {
        LazyVStack(spacing: 10) {
            ForEach(store.DMRooms, id: \.id) { room in
                HStack {
                    LoadedImage(urlString: room.user.profileImage ?? "", size: 24)
                    
                    let unreadCount = store.dmUnreads[room]?.count
                    
                    Text(room.user.nickname)
                        .applyFont(font: unreadCount ?? 0 <= 0 ? .bodyRegular : .bodyBold)
                    
                    Spacer()
                    
                    Text("\(unreadCount ?? 0)")
                        .badge()
                        .opacity(unreadCount ?? 0 <= 0 ? 0 : 1)
                }
                .padding(.vertical, 5)
                .asButton {
                    store.send(.dmCellTapped(room))
                }
            }
        }
    }
    
    func makeAddButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(.plus)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(text)
                    .applyFont(font: .bodyRegular)
                Spacer()
            }
            .foregroundStyle(.secondaryText)
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

//#Preview {
//    HomeView(store: Store(initialState: Home.State()) {
//        Home()
//    })
//}
