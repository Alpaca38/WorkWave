//
//  SignUpView.swift
//  WorkWave
//
//  Created by 조규연 on 11/2/24.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    @Bindable var store: StoreOf<SignUp>
    
    var body: some View {
        NavigationStack {
            VStack() {
                ZStack {
                    HStack {
                        Image(.close)
                            .asButton {
                                store.send(.exitButtonTapped)
                            }
                        Spacer()
                    }
                    Text("회원가입")
                        .applyFont(font: .title1)
                }
                .padding()
                
                Form {
                    Text("asdf")
                }
                
                Spacer()
            }
        }
    }
}
