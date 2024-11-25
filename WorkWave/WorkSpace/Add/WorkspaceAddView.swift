//
//  WorkspaceAddView.swift
//  WorkWave
//
//  Created by 조규연 on 11/12/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkspaceAddView: View {
    @Bindable var store: StoreOf<WorkspaceAdd>
    
    var body: some View {
        VStack {
            SheetHeaderView(text: "워크스페이스 생성") {
                store.send(.exitButtonTapped)
            }
            
            workspaceInfoView
            
            Spacer()
            
            CustomButton(title: "완료", font: .title2, titleColor: .white, tintColor: store.completeButtonValid ? .brandGreen : .inactive) {
                store.send(.completeButtonTapped)
            }
            .padding()
            .disabled(!store.completeButtonValid)
        }
        .background(.primaryBackground)
        .toast(message: store.toast.toastMessage, isPresented: $store.toast.isToastPresented)
    }
    
    var workspaceInfoView: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brandGreen)
                
                Image(.workspace)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 60)
                    .offset(y: 3)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(.camera)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .offset(x: 8, y: 8)
                    }
                }
            }
            .frame(width: 70, height: 70)
            .padding()
            .asButton {
                store.send(.imageTapped)
            }
            
            CustomTextField(title: "워크스페이스 이름", placeholder: "워크스페이스 이름을 입력하세요 (필수)", text: $store.workspaceName)
            
            CustomTextField(title: "워크스페이스 설명", placeholder: "워크스페이스를 설명하세요 (옵션)", text: $store.workspaceDescription)
        }
    }
}
