//
//  AddButton.swift
//  WorkWave
//
//  Created by 조규연 on 1/21/25.
//

import SwiftUI

struct AddButton: View {
    let text: String
    let action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(.plus)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(text)
                    .applyFont(font: .bodyRegular)
                Spacer()
            }
            .foregroundStyle(.secondaryText)
        }
    }
}
