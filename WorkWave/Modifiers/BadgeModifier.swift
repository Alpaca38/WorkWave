//
//  BadgeModifier.swift
//  WorkWave
//
//  Created by 조규연 on 1/12/25.
//

import SwiftUI

private struct BadgeModifier: ViewModifier {
    let backgroundColor: Color
    let textColor: Color
    
    init(backgroundColor: Color, textColor: Color) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(Capsule())
    }
    
}

extension View {
    func badge(backgroundColor: Color = .brandGreen, textColor: Color = .white) -> some View {
        modifier(BadgeModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}
