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
    case signup(query: SignupRequest)
}

extension UserRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkEmailValid:
                .post
        case .signup:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .checkEmailValid:
            "/v1/users/validation/email"
        case .signup:
            "/v1/users/join"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .checkEmailValid, .signup:
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
        case .checkEmailValid, .signup:
            nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .checkEmailValid(let query):
            return try? encoder.encode(query)
        case .signup(let query):
            return try? encoder.encode(query)
        }
    }
}
