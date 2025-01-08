//
//  SideView.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import SwiftUI
import ComposableArchitecture

struct SideView: View {
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        action()
                    }
                
                WorkspaceListView(store: Store(initialState: WorkspaceList.State()) {
                    WorkspaceList()
                })
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height)
                .background(Color.white)
                .cornerRadius(25, corners: [.topRight, .bottomRight])
            }
        }
        .ignoresSafeArea()
        .transition(.move(edge: .leading))
    }
}

