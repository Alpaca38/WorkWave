//
//  OnboardingView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    @Bindable var store: StoreOf<Onboarding>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("WorkWave와 함께 어디서든 팀을 만들어보세요")
                    .applyFont(font: .title1)
                
                Spacer()
                
                Image(.onboarding)
                
                Spacer()
                
                CustomButton(title: "시작하기", font: .bodyBold, titleColor: .white, tintColor: .brandGreen) {
                    store.send(.setSheet(isPresented: true))
                }
            }
            .padding()
            .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
                if let store = store.scope(state: \.optionalSignUp, action: \.optionalSignUp) {
                    SignUpView(store: store)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}
