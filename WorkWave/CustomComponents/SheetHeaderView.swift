//
//  SheetHeaderView.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import SwiftUI

struct SheetHeaderView: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Image(.close)
                    .asButton {
                        action()
                    }
                Spacer()
            }
            Text(text)
                .font(.system(size: 17, weight: .bold))
        }
        .padding(.horizontal)
        .padding(.top, 24)
        .padding(.bottom, 8)
        .background(.secondaryBackground)
    }
}
