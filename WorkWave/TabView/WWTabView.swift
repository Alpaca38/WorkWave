//
//  WWTabView.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import SwiftUI

struct WWTabView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
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
        }
    }
}
