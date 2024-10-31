//
//  ContentView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI

struct ContentView: View {
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
//
//#Preview {
//    ContentView()
//}
