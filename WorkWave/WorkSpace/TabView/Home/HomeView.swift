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
    
    @Dependency(\.imageClient) var imageClient
    
    var body: some View {
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
    }
    
    var defaultView: some View {
        VStack {
            HomeHeaderView(coverImage: store.currentWorkspace?.coverImage ?? "", profileImage: store.myProfile?.profileImage ?? "", size: 32, title: store.currentWorkspace?.name ?? "")
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
                // addTeammates
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
                    Image(.profile2) // dummy
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(room.user.nickname)
                        .applyFont(font: .bodyRegular)
                    
                    Spacer()
                }
                .padding(.vertical, 5)
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
}

//#Preview {
//    HomeView(store: Store(initialState: Home.State()) {
//        Home()
//    })
//}
