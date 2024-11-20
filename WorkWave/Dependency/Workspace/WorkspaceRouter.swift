//
//  WorkspaceRouter.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

enum WorkspaceRouter {
    @Dependency(\.jwtKeyChain) static var jwtKeyChain
    
    case checkWorkspaces
    
}

extension WorkspaceRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkWorkspaces:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .checkWorkspaces:
            "/v1/workspaces"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .checkWorkspaces:
            [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.authorization.rawValue : WorkspaceRouter.jwtKeyChain.accessToken ?? "",
                Header.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    
}
