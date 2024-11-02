//
//  CustomButton.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let font: WWFont
    let titleColor: Color
    let tintColor: Color
    let action: () -> Void
    
    init(title: String, font: WWFont, titleColor: Color, tintColor: Color, action: @escaping () -> Void) {
        self.title = title
        self.font = font
        self.titleColor = titleColor
        self.tintColor = tintColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .applyFont(font: font)
                .frame(maxWidth: .infinity)
                .foregroundStyle(titleColor)
                .padding(.vertical, 4)
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .tint(tintColor)
    }
}
