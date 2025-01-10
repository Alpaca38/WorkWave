//
//  UserRouter.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

enum UserRouter {
    @Dependency(\.jwtKeyChain) static var jwtKeyChain
    
    case checkEmailValid(query: ValidationEmailRequest)
    case signup(query: SignupRequest)
    case login(query: LoginRequest)
    case fetchMyProfile
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
        case .login:
                .post
        case .fetchMyProfile:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .checkEmailValid:
            "/v1/users/validation/email"
        case .signup:
            "/v1/users/join"
        case .login:
            "/v1/users/login"
        case .fetchMyProfile:
            "/v1/users/me"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .checkEmailValid, .signup, .login:
            [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.sesacKey
            ]
        case .fetchMyProfile:
            [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.sesacKey.rawValue : APIKey.sesacKey,
                Header.authorization.rawValue : UserRouter.jwtKeyChain.accessToken ?? ""
            ]
        }
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .checkEmailValid, .signup, .login, .fetchMyProfile:
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
        case .login(let query):
            return try? encoder.encode(query)
        case .fetchMyProfile:
            return nil
        }
    }
}
