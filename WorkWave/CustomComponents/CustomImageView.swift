//
//  CustomImageView.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import SwiftUI

struct CustomImageView: View {
    var urlString: String
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    
    @State var uiImage: UIImage?
    
    var body: some View {
        imageView()
            .onChange(of: urlString) { _, newValue in
                Task {
                    do {
                        let result = try await DefaultNetworkManager.shared.requestImage(
                            ImageRouter.fetchImage(path: newValue)
                        )
                        uiImage = result
                    } catch {}
                }
            }
            .task {
                // 초기 로드
                guard !urlString.isEmpty else { return }
                do {
                    let result = try await DefaultNetworkManager.shared.requestImage(
                        ImageRouter.fetchImage(path: urlString)
                    )
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
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            Image(.noPhotoA)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
