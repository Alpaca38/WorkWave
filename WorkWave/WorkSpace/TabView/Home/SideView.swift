//
//  SideView.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import SwiftUI
import ComposableArchitecture

struct SideView: View {
    @Binding var currentWorkspace: WorkspaceDTO.ResponseElement?
    let action: () -> Void
    
    init(currentWorkspace: Binding<WorkspaceDTO.ResponseElement?>, action: @escaping () -> Void) {
        self._currentWorkspace = currentWorkspace
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        action()
                    }
                
                WorkspaceListView(currentWorkspace: $currentWorkspace, store: Store(initialState: WorkspaceList.State(currentWorkspace: currentWorkspace)) {
                    WorkspaceList()
                }, close: action)
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height)
                .background(Color.white)
                .cornerRadius(25, corners: [.topRight, .bottomRight])
            }
        }
        .ignoresSafeArea()
        .transition(.move(edge: .leading))
    }
}

