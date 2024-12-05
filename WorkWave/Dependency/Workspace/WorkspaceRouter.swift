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
    case createWorkspace
    
}

extension WorkspaceRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkWorkspaces:
                .get
        case .createWorkspace:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .checkWorkspaces, .createWorkspace:
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
        case .createWorkspace:
            [
                Header.contentType.rawValue : Header.multipart.rawValue,
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
