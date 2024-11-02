//
//  CustomTextField.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .applyFont(font: .title2)
            TextField(placeholder, text: $text)
                .padding(10) // 텍스트 필드 내부 여백
                .frame(height: 44)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .applyFont(font: .bodyRegular)
        }
        .padding()
    }
}
