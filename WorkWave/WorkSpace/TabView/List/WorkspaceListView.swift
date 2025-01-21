//
//  WorkspaceListView.swift
//  WorkWave
//
//  Created by 조규연 on 12/3/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkspaceListView: View {
    @Binding var currentWorkspace: WorkspaceDTO.ResponseElement?
    @Bindable var store: StoreOf<WorkspaceList>
    
    let close: () -> Void

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
        ScrollView {
            LazyVStack() {
                ForEach(store.workspaces, id: \.id) { workspace in
                    HStack {
                        LoadedImage(urlString: workspace.coverImage, size: 44, isCoverImage: true)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workspace.name)
                                .applyFont(font: .bodyBold)
                            
                            Text(workspace.formattedCreatedAt)
                                .applyFont(font: .bodyRegular)
                                .foregroundStyle(.secondaryText)
                        }
                        
                        Spacer()
                        
                        Image(.threeDots)
                            .renderingMode(.template)
                            .foregroundStyle(.black)
                    }
                    .padding()
                    .background(workspace.name == store.currentWorkspace?.name ? .brandGray : .clear)
                    .asButton {
                        // 워크스페이스 교체
                        store.send(.selectWorkspace(workspace))
                        currentWorkspace = workspace
                        close()
                    }
                    
                }
                
                Spacer()
                
                AddButton(text: "워크스페이스 추가") {
                    store.send(.addWorkspaceTapped)
                }
                .padding()
            }
        }
    }
}
