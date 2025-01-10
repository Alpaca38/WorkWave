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
    
    var header: HTTPHeaders {
        [
            Header.contentType.rawValue : Header.json.rawValue,
            Header.authorization.rawValue : WorkspaceRouter.jwtKeyChain.accessToken ?? "",
            Header.sesacKey.rawValue : APIKey.sesacKey,
            "RefreshToken": WorkspaceRouter.jwtKeyChain.refreshToken ?? ""
        ]
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    
}
