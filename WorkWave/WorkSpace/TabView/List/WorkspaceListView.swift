//
//  WorkspaceListView.swift
//  WorkWave
//
//  Created by 조규연 on 12/3/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkspaceListView: View {
    @Bindable var store: StoreOf<WorkspaceList>

    var body: some View {
        VStack {
            headerView
            
            if store.workspaces.isEmpty {
                emptyListView
            } else {
                listView
            }
        }
        .sheet(isPresented: $store.isAddWorkspacePresented) {
            if let store = store.scope(state: \.workspaceAdd, action: \.workspaceAdd) {
                WorkspaceAddView(store: store)
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            store.send(.fetchWorkspaces)
        }
    }
    
    var headerView: some View {
        HStack {
            Text("워크스페이스")
                .applyFont(font: .title1)
                .padding(.horizontal)
                .padding(.top, 60)
                .padding(.bottom, 8)
            
            Spacer()
        }
        .background(.primaryBackground)
    }
    
    var emptyListView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("워크스페이스를 찾을 수 없어요.")
                .applyFont(font: .title1)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로 워크스페이스를 생성해주세요.")
                .applyFont(font: .bodyRegular)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            CustomButton(title: "워크스페이스 생성", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                store.send(.addWorkspaceTapped)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var listView: some View {
        List(store.workspaces, id: \.id) { workspace in
            Text(workspace.name)
                .applyFont(font: .bodyBold)
                .padding(.vertical, 8)
        }
    }
}
