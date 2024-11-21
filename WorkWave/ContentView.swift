//
//  ContentView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @AppStorage("isSignedUp") private var isSignedUp: Bool = false
    
    var body: some View {
        if isSignedUp {
            WWTabView(store: Store(initialState: WWTab.State()) {
                WWTab()
            })
        } else {
            OnboardingView(store: Store(initialState: Onboarding.State()) {
                Onboarding()
            })
        }
    }
}
//
//#Preview {
//    ContentView()
//}
