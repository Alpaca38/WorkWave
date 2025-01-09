//
//  ImageRouter.swift
//  WorkWave
//
//  Created by 조규연 on 1/9/25.
//

import Foundation
import Alamofire
import ComposableArchitecture

enum ImageRouter {
    @Dependency(\.jwtKeyChain) static var jwtKeyChain
    
    case fetchImage(path: String)
}

extension ImageRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .fetchImage:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchImage(let path):
            return "/v1\(path)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchImage:
            return [
                Header.sesacKey.rawValue: APIKey.sesacKey,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.authorization.rawValue: ImageRouter.jwtKeyChain.accessToken ?? ""
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchImage:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchImage:
            return nil
        }
    }
}
