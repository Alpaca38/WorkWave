//
//  HomeEmptyView.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeEmptyView: View {
    @Bindable var store: StoreOf<WorkspaceInitial>
    
    var body: some View {
        ZStack {
            emptyView
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 { // 왼쪽 가장자리에서 드래그했을 때
                                store.send(.workspaceListTapped, animation: .easeInOut)
                            }
                        }
                )
            
            if store.isListPresented {
                SideView {
                    store.send(.closeWorkspaceList, animation: .easeInOut)
                }
            }
        }
    }
    
    var emptyView: some View {
        VStack {
            HomeHeaderView(coverImage: Image(.rectangle4044), title: "No Workspace", profileImage: Image(.noPhotoA))
                .padding(.horizontal)
                .onTapGesture {
                    store.send(.workspaceListTapped, animation: .easeInOut)
                }
            
            Divider()
            
            VStack(spacing: 12) {
                Text("워크스페이스를 찾을 수 없어요.")
                    .applyFont(font: .title1)
                    .padding(.top, 16)
                
                Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 워크스페이스를 생성해주세요")
                    .applyFont(font: .bodyRegular)
                    .multilineTextAlignment(.center)
                
                Image(.workspaceEmpty)
                
                Spacer()
                
                CustomButton(title: "워크스페이스 생성", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                    // Workspace add 로 이동
                    store.send(.setSheet(isPresented: true))
                }
                .padding()
            }
            .sheet(isPresented: $store.isSheetPresented) {
                if let store = store.scope(state: \.workspaceAdd, action: \.workspaceAdd) {
                    WorkspaceAddView(store: store)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}
