//
//  UserRouter.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case checkEmailValid(query: ValidationEmailRequest)
}

extension UserRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkEmailValid:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .checkEmailValid:
            "/v1/users/validation/email"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .checkEmailValid:
            [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .checkEmailValid:
            nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .checkEmailValid(let query):
            return try? encoder.encode(query)
        }
    }
}
