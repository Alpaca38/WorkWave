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
                    uiImage = await fetchImage(path: newValue)
                }
            }
            .task {
                // 초기 로드
                guard !urlString.isEmpty else { return }
                uiImage = await fetchImage(path: urlString)
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

extension CustomImageView {
    func fetchImage(path: String) async -> UIImage? {
        if let image = ImageFileManager.shared.loadImage(fileName: path) {
            // 로컬 데이터 리턴
            return image
        } else {
            do {
                let result = try await DefaultNetworkManager.shared.requestImage(
                    ImageRouter.fetchImage(path: path)
                )
                return result
            } catch {
                print("이미지 통신 실패")
                return nil
            }
        }
    }
}
