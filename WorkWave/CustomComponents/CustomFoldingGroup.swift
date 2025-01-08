//
//  CustomFoldingGroup.swift
//  WorkWave
//
//  Created by 조규연 on 1/8/25.
//

import SwiftUI

struct CustomFoldingGroup<Content: View>: View {
    let content: Content
    let label: String
    @Binding var isExpanded: Bool
    
    init(label: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.label = label
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(label)
                        .applyFont(font: .title2)
                    Spacer()
                    Image(.chevronRight)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeIn, value: isExpanded)
                }
            }
            if isExpanded {
                content
            }
        }
    }
}
