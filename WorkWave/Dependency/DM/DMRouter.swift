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
    case createDMRoom(workspaceID: String, body: CreateDMRoomRequest)
}

extension DMRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDMRooms:
                .get
        case .createDMRoom:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMRooms(let workspaceID):
            "/v1/workspaces/\(workspaceID)/dms"
        case .createDMRoom(let workspaceID, _):
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
        let encoder = JSONEncoder()
        switch self {
        case .createDMRoom(_, let body):
            return try? encoder.encode(body)
        default:
            return nil
        }
    }
    
    
}

