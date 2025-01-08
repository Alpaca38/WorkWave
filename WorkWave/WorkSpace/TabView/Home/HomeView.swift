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
        defaultView
            .gesture(
            DragGesture()
                .onEnded({ value in
                    if value.translation.width > 100 {
                        // workspaceList
                    }
                })
            )
    }
    
    var defaultView: some View {
        VStack {
            HomeHeaderView(coverImage: Image(.rectangle4044), title: "iOS Developers Study", profileImage: Image(.noPhotoA))
                .padding(.horizontal)
                .onTapGesture {
                    // workspaceList
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
                
            }
            
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
    
//    struct DMListView: View {
//        let DMs: [String] = ["캠퍼스지킴이", "스유 뽀개기", "앱스토어 홍보"] // dummy
//        
//        var body: some View {
//            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
//        }
//    }
    
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
