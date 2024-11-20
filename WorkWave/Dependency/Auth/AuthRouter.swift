//
//  AuthRouter.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

enum AuthRouter {
    @Dependency(\.jwtKeyChain) static var jwtKeyChain
    case refresh
}

extension AuthRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var path: String {
        "/v1/auth/refresh"
    }
    
    var header: [String : String] {
        [
            Header.contentType.rawValue : Header.json.rawValue,
            Header.authorization.rawValue : WorkspaceRouter.jwtKeyChain.accessToken ?? "",
            Header.sesacKey.rawValue : APIKey.sesacKey
        ]
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "RefreshToken", value: WorkspaceRouter.jwtKeyChain.refreshToken ?? "")
        ]
    }
    
    var body: Data? {
        nil
    }
    
    
}
