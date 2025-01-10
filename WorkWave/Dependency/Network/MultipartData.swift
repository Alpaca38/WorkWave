//
//  MultipartData.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation

struct MultipartData {
    let data: Data
    let name: String
    var fileName: String?
    let mimeType = "image/jpeg"
}
