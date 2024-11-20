//
//  HomeHeaderView.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import SwiftUI

struct HomeHeaderView: View {
    let coverImage: Image
    let title: String
    let profileImage: Image
    
    var body: some View {
        HStack {
            coverImage
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("No Workspace")
                .applyFont(font: .title1)
            
            Spacer()
            
            profileImage
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
