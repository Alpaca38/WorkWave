//
//  ResponseErrorMapper.swift
//  WorkWave
//
//  Created by 조규연 on 11/30/24.
//

import Foundation

protocol ResponseErrorMapper {
    associatedtype ResponseError: Error
    func mappingError(_ identifier: String) -> Error?
}
