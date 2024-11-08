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
                // Home empty로 이동
            }
            
            Text("출시 준비 완료")
                .applyFont(font: .title1)
                .padding(.top, 16)
            
            Text("nickname님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!")
                .applyFont(font: .bodyRegular)
                .multilineTextAlignment(.center)
            
            Image(.launching)
            
            Spacer()
            
            CustomButton(title: "워크스페이스 생성", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                // Workspace add 로 이동
            }
            .padding()
        }
        .background(.primaryBackground)
    }
}
