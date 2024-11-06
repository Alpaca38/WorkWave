//
//  ErrorResponse.swift
//  WorkWave
//
//  Created by 조규연 on 11/6/24.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    let errorCode: String
}
