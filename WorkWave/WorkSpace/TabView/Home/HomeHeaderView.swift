//
//  HomeHeaderView.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeHeaderView: View {
    @State private var showProfile = false
    let coverImage: String
    let myProfile: MyProfileResponse?
    let size: CGFloat
    let title: String
    
    var body: some View {
        HStack {
            LoadedImage(urlString: coverImage, size: size, isCoverImage: true)
            
            Text(title)
                .applyFont(font: .title1)
            
            Spacer()
            
            LoadedImage(urlString: myProfile?.profileImage ?? "", size: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(.black, lineWidth: 2))
                .asButton {
                    showProfile = true
                }
        }
        .navigationDestination(isPresented: $showProfile) {
            if let profile = myProfile {
                ProfileView(
                    store: Store(
                        initialState: Profile.State(
                            profileType: .me,
                            nickname: profile.nickname,
                            email: profile.email,
                            profileImage: profile.profileImage ?? "",
                            phoneNumber: profile.phone!.isEmpty ? "010-0000-0000" : profile.phone!
                        )
                    ) {
                        Profile()
                    }
                )
            }
        }
    }
}
