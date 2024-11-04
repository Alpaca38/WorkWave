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
            .background(.primaryBackground)
            .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
                AuthView(store: Store(initialState: Auth.State()) {
                    Auth()
                })
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.3)])
            }
        }
    }
}
