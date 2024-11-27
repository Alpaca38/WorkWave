//
//  NetworkBaseAdaptor.swift
//  WorkWave
//
//  Created by 조규연 on 11/30/24.
//

import Foundation
import Alamofire

struct NetworkingBaseAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        guard let path = urlRequest.url?.absoluteString,
              let requestURL = URL(string: "\(APIKey.baseURL)\(path)")
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        urlRequest.headers.add(name: Header.sesacKey.rawValue, value: APIKey.sesacKey)
        urlRequest.url = requestURL
        completion(.success(urlRequest))
    }
    
}
