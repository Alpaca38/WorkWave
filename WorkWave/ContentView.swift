//
//  ContentView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        OnboardingView(store: Store(initialState: Onboarding.State()) {
            Onboarding()
        })
    }
}
//
//#Preview {
//    ContentView()
//}
