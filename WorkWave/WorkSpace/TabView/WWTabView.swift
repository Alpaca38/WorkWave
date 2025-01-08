//
//  WWTabView.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import SwiftUI
import ComposableArchitecture

struct WWTabView: View {
    let store: StoreOf<WWTab>
    
    var body: some View {
        NavigationStack {
            if store.workSpaceExist {
                TabView {
                    HomeView(store: Store(initialState: Home.State()) {
                        Home()
                    })
                        .tabItem {
                            Image(.homeActive)
                                .renderingMode(.template)
                            Text("홈")
                        }
                    
                    DMView()
                        .tabItem {
                            Image(.messageActive)
                                .renderingMode(.template)
                            Text("DM")
                        }
                    
                    SearchView()
                        .tabItem {
                            Image(.profileActive)
                                .renderingMode(.template)
                            Text("검색")
                        }
                    
                    SettingView()
                        .tabItem {
                            Image(.settingActive)
                                .renderingMode(.template)
                            Text("설정")
                        }
                }
                .tint(.black)
            } else {
                HomeEmptyView(store: Store(initialState: WorkspaceInitial.State()) {
                    WorkspaceInitial()
                })
            }
        }
        .task {
            store.send(.checkWorkspaceExist)
        }
    }
}
