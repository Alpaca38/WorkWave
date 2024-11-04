//
//  CustomButton.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI

struct CustomButton: View {
    let image: Image?
    let title: String
    let font: WWFont
    let titleColor: Color
    let tintColor: Color
    let action: () -> Void
    
    init(image: Image? = nil, title: String, font: WWFont, titleColor: Color, tintColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.font = font
        self.titleColor = titleColor
        self.tintColor = tintColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack() {
                if let image {
                    image
                }
                Text(title)
                    .applyFont(font: font)
                    .foregroundStyle(titleColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .tint(tintColor)
    }
}
