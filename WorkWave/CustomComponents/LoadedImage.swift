//
//  LoadedImage.swift
//  WorkWave
//
//  Created by 조규연 on 1/9/25.
//

import SwiftUI
import ComposableArchitecture

struct LoadedImage: View {
    @State var uiImage: UIImage?
    
    var urlString: String
    var size: CGFloat
    var isCoverImage: Bool = false
    
    @Dependency(\.imageClient) var imageClient
    
    var body: some View {
        imageView()
            .onChange(of: urlString, { oldValue, newValue in
                Task {
                    do {
                        let result = try await imageClient.fetchImage(newValue)
                        uiImage = result
                    } catch {}
                }
            })
            .task {
                // 초기 로드
                guard !urlString.isEmpty else { return }
                do {
                    let result = try await imageClient.fetchImage(urlString)
                    uiImage = result
                } catch {}
            }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: isCoverImage ? 0 : size * 0.2))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        } else {
            Image(isCoverImage ? "placeholder" : "deafaultProfile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: isCoverImage ? 0 : size * 0.2))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}
