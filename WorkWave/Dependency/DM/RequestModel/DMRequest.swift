//
//  DMRequest.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import Foundation

struct DMRequest: Encodable {
    let content: String?
    let files: [Data]?
}
