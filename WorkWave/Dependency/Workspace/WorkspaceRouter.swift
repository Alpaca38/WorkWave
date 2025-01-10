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
    case createWorkspace(AddWorkspaceRequest)
    case fetchMembers(workspaceID: String)
}

extension WorkspaceRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkWorkspaces, .fetchMembers:
                .get
        case .createWorkspace:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .checkWorkspaces, .createWorkspace:
            "/v1/workspaces"
        case .fetchMembers(let workspaceID):
            "/v1/workspaces/\(workspaceID)/members"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .checkWorkspaces, .fetchMembers:
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
    
    var parameters: Parameters? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    var multipartData: [MultipartData]? {
        switch self {
        case .createWorkspace(let body):
            [
                MultipartData(
                    data: body.name.data(using: .utf8) ?? Data(),
                    name: "name"
                ),
                MultipartData(
                    data: body.description?.data(using: .utf8) ?? Data(),
                    name: "description"
                ),
                MultipartData(
                    data: body.image,
                    name: "image",
                    fileName: "image.jpg"
                )
            ]
        default:
            nil
        }
    }
    
}
