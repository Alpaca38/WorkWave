//
//  HomeHeaderView.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import SwiftUI

struct HomeHeaderView: View {
    let coverImage: String
    let profileImage: String
    let size: CGFloat
    let title: String
    
    var body: some View {
        HStack {
            LoadedImage(urlString: coverImage, size: size, isCoverImage: true)
            
            Text(title)
                .applyFont(font: .title1)
            
            Spacer()
            
            LoadedImage(urlString: profileImage, size: size)
        }
    }
}
