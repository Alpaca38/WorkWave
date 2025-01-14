//
//  CustomAlertView.swift
//  WorkWave
//
//  Created by 조규연 on 1/14/25.
//

import SwiftUI

private struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    let title: String
    let message: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text(title)
                    .applyFont(font: .title2)
                    .foregroundStyle(.black)
                Text(message)
                    .applyFont(font: .bodyRegular)
                    .foregroundStyle(.secondaryText)
                    .multilineTextAlignment(.center)
                HStack {
                    CustomButton(title: "취소", font: .title2, titleColor: .white, tintColor: .inactive) {
                        onCancel()
                    }
                    
                    CustomButton(title: "로그아웃", font: .title2, titleColor: .white, tintColor: .brandGreen) {
                        onConfirm()
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding()
        }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, title: String, message: String, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) -> some View{
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlertView(isPresented: isPresented, title: title, message: message, onConfirm: onConfirm, onCancel: onCancel)
                    .transition(.opacity)
            }
        }
    }
}
