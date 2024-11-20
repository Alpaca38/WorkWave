//
//  WorkspaceResponse.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation

struct WorkspaceDTO: Decodable {
    let response: Response
}

extension WorkspaceDTO {
    struct ResponseElement: Decodable {
        let workspaceID, name, description, coverImage: String
        let ownerID, createdAt: String

        enum CodingKeys: String, CodingKey {
            case workspaceID = "workspace_id"
            case name, description, coverImage
            case ownerID = "owner_id"
            case createdAt
        }
    }
    
    typealias Response = [ResponseElement]
}
