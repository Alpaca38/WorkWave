//
//  ChattingImageView.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import SwiftUI

struct ChattingImageView: View {
    var imageNames: [String]
    
    var body: some View {
        if imageNames.count == 2 || imageNames.count == 3 {
            HStack {
                if imageNames.count == 2 {
                    twoImages(imageNames)
                } else {
                    threeImages(imageNames)
                }
            }
            .frame(
                width: UIScreen.main.bounds.width*0.6,
                height: UIScreen.main.bounds.width*0.2
            )
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            HStack {
                if imageNames.count == 1 {
                    oneImage(imageNames)
                } else if imageNames.count == 4 {
                    fourImages(imageNames)
                } else {
                    fiveImages(imageNames)
                }
            }
            .frame(
                width: UIScreen.main.bounds.width*0.6,
                height: UIScreen.main.bounds.width*0.4
            )
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func oneImage(_ imageStr: [String]) -> some View {
        CustomImageView(
            urlString: imageStr[0],
            width: UIScreen.main.bounds.width*0.6,
            height: UIScreen.main.bounds.width*0.4,
            cornerRadius: 12
        )
    }
    private func twoImages(_ imageStr: [String]) -> some View {
        HStack(spacing: 1) {
            CustomImageView(
                urlString: imageStr[0],
                width: UIScreen.main.bounds.width*0.3,
                height: UIScreen.main.bounds.width*0.2,
                cornerRadius: 4
            )
            CustomImageView(
                urlString: imageStr[1],
                width: UIScreen.main.bounds.width*0.3,
                height: UIScreen.main.bounds.width*0.2,
                cornerRadius: 4
            )
        }
    }
    
    private func threeImages(_ imageStr: [String]) -> some View {
        HStack(spacing: 1) {
            CustomImageView(
                urlString: imageStr[0],
                width: UIScreen.main.bounds.width*0.2,
                height: UIScreen.main.bounds.width*0.2,
                cornerRadius: 4
            )
            CustomImageView(
                urlString: imageStr[1],
                width: UIScreen.main.bounds.width*0.2,
                height: UIScreen.main.bounds.width*0.2,
                cornerRadius: 4
            )
            CustomImageView(
                urlString: imageStr[2],
                width: UIScreen.main.bounds.width*0.2,
                height: UIScreen.main.bounds.width*0.2,
                cornerRadius: 4
            )
        }
    }
    
    private func fourImages(_ imageStr: [String]) -> some View {
        let firstPart = Array(imageStr.prefix(2))
        let secondPart = Array(imageStr.suffix(imageStr.count - 2))
        return VStack(spacing: 1) {
            twoImages(firstPart)
            twoImages(secondPart)
        }
    }
    
    private func fiveImages(_ imageStr: [String]) -> some View {
        let firstPart = Array(imageStr.prefix(2))
        let secondPart = Array(imageStr.suffix(imageStr.count - 2))
        return VStack(spacing: 1) {
            twoImages(firstPart)
            threeImages(secondPart)
        }
    }
}
