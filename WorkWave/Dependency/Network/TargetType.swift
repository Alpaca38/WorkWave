//
//  TargetType.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var queryItems: [URLQueryItem]? { get }
    var encoding: ParameterEncoding { get }
    var body: Data? { get }
    var multipartData: [MultipartData]? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url.appendingPathComponent(path), method: method)
        request.headers = header
        request.httpBody = body
        
        if let queryItems {
            request.url?.append(queryItems: queryItems)
        }
        
        return try encoding.encode(request, with: parameters)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartData: [MultipartData]? {
        return nil
    }
}
