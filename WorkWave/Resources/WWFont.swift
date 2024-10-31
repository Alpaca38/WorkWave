//
//  WWFont.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI

enum WWFont: String {
    case title1
    case title2
    case bodyBold
    case bodyRegular
    case caption
    
    var size: CGFloat {
        switch self {
        case .title1:
            22
        case .title2:
            14
        case .bodyBold:
            13
        case .bodyRegular:
            13
        case .caption:
            12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1:
            30
        case .title2:
            20
        case .bodyBold:
            18
        case .bodyRegular:
            18
        case .caption:
            18
        }
    }
    
    var lineSpacing: CGFloat {
        return (lineHeight - size) / 2
    }
    
    var verticalPadding: CGFloat {
        return lineSpacing
    }
    
    var wwFont: Font {
        switch self {
        case .title1:
            Font.system(size: size, weight: .bold)
        case .title2:
            Font.system(size: size, weight: .bold)
        case .bodyBold:
            Font.system(size: size, weight: .bold)
        case .bodyRegular:
            Font.system(size: size, weight: .regular)
        case .caption:
            Font.system(size: size, weight: .regular)
        }
    }
}
