//
//  Toast.swift
//  WorkWave
//
//  Created by 조규연 on 11/6/24.
//

import SwiftUI

private struct Toast: ViewModifier {
    let message: String
    @Binding var isPresented: Bool
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                toastView
            }
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Text(message)
                .applyFont(font: .bodyRegular)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.brandGreen)
                )
                .padding(.bottom, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
        }
    }
}

extension View {
    func toast(message: String, isPresented: Binding<Bool>, duration: TimeInterval = 2) -> some View {
        modifier(Toast(message: message, isPresented: isPresented, duration: duration))
    }
}

struct ToastState: Equatable {
    var toastMessage: String
    var isToastPresented: Bool = false
}
