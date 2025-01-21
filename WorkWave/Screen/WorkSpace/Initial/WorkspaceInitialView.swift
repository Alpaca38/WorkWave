//
//  WorkSpaceInitial.swift
//  WorkWave
//
//  Created by 조규연 on 11/8/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkspaceInitialView: View {
    @Bindable var store: StoreOf<WorkspaceInitial>
    
    var body: some View {
        VStack(spacing: 12) {
            SheetHeaderView(text: "시작하기") {
                store.send(.exitButtonTapped(isPresented: true)) // Home 으로 이동, workspace 존재 여부에 따라 UI다르게 구성
            }
            
            Text("출시 준비 완료")
                .applyFont(font: .title1)
                .padding(.top, 16)
            
            Text("\(UserDefaultsManager.user.nickname)님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!")
                .applyFont(font: .bodyRegular)
                .multilineTextAlignment(.center)
            
            Image(.launching)
            
            Spacer()
            
            CustomButton(title: "워크스페이스 생성", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                // Workspace add 로 이동
                store.send(.setSheet(isPresented: true))
            }
            .padding()
        }
        .background(.primaryBackground)
        .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
            WorkspaceAddView(store: Store(initialState: WorkspaceAdd.State()) {
                WorkspaceAdd()
            })
        }
        .fullScreenCover(isPresented: $store.isHomePresented.sending(\.exitButtonTapped)) {
            WWTabView(store: Store(initialState: WWTab.State()) {
                WWTab()
            })
        }
    }
}
