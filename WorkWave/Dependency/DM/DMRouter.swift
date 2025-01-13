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
    case fetchDMHistory(workspaceID: String, roomID: String, cursorDate: String)
    case fetchUnreadDMCount(workspaceID: String, roomID: String, after: String)
    case sendMessage(workspaceID: String, roomID: String, body: DMRequest)
}

extension DMRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDMRooms, .fetchDMHistory, .fetchUnreadDMCount:
                .get
        case .createDMRoom, .sendMessage:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMRooms(let workspaceID):
            "/v1/workspaces/\(workspaceID)/dms"
        case .createDMRoom(let workspaceID, _):
            "/v1/workspaces/\(workspaceID)/dms"
        case .fetchDMHistory(let workspaceID, let roomID, _):
            "/v1/workspaces/\(workspaceID)/dms/\(roomID)/chats"
        case .fetchUnreadDMCount(let workspaceID, let roomID, _):
            "/v1/workspaces/\(workspaceID)/dms/\(roomID)/unreads"
        case .sendMessage(let workspaceID, let roomID, _):
            "/v1/workspaces/\(workspaceID)/dms/\(roomID)/chats"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .sendMessage:
            [
                Header.contentType.rawValue : Header.multipart.rawValue,
                Header.authorization.rawValue : DMRouter.jwtKeyChain.accessToken ?? "",
                Header.sesacKey.rawValue : APIKey.sesacKey
            ]
        default:
            [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.authorization.rawValue : DMRouter.jwtKeyChain.accessToken ?? "",
                Header.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .fetchDMHistory(_, _, let cursorDate):
            return ["cursor_date": cursorDate]
        case .fetchUnreadDMCount(_, _, let after):
            return ["after": after]
        default:
            return nil
        }
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
    
    var multipartData: [MultipartData]? {
        switch self {
        case .sendMessage(_, _, let body):
            // Text
            var multipartDataList = [
                MultipartData(
                    data: body.content?.data(using: .utf8) ?? Data(),
                    name: "content"
                )
            ]
            // Image
            if let files = body.files {
                files.enumerated().forEach { index, imageData in
                    let multipartData = MultipartData(
                        data: imageData,
                        name: "files",
                        fileName: "image\(index).jpg"
                    )
                    multipartDataList.append(multipartData)
                }
            }
            return multipartDataList
        default:
            return nil
        }
    }
}

