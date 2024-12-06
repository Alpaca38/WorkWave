//
//  AddWorkspaceRequest.swift
//  WorkWave
//
//  Created by 조규연 on 12/6/24.
//

import Foundation

struct AddWorkspaceRequest: Encodable {
    var name: String
    var description: String?
    var image: Data?
}
