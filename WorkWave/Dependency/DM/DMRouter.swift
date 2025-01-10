//
//  DMRouter.swift
//  WorkWave
//
//  Created by 조규연 on 1/10/25.
//

import Foundation
import Alamofire
import ComposableArchitecture

enum DMRouter {
    @Dependency(\.jwtKeyChain) static var jwtKeyChain
    
    case fetchDMRooms(workspaceID: String)
}

extension DMRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDMRooms(let workspaceID):
                .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMRooms(let workspaceID):
            "/v1/workspaces/\(workspaceID)/dms"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        [
            Header.contentType.rawValue : Header.json.rawValue,
            Header.authorization.rawValue : DMRouter.jwtKeyChain.accessToken ?? "",
            Header.sesacKey.rawValue : APIKey.sesacKey
        ]
    }
    
    var parameters: Alamofire.Parameters? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    
}

