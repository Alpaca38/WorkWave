//
//  FontModifier.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI

private struct FontModifier: ViewModifier {
    let font: WWFont
    
    init(font: WWFont) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        content
            .font(font.wwFont)
            .lineSpacing(font.lineSpacing)
            .padding(.vertical, font.verticalPadding)
    }
}

extension View {
    func applyFont(font: WWFont) -> some View {
        modifier(FontModifier(font: font))
    }
}
