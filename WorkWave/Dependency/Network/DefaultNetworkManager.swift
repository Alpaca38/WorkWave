//
//  DefaultNetworkManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/6/24.
//

import Foundation
import Alamofire

final class DefaultNetworkManager: NetworkManager {
    static let shared = DefaultNetworkManager()
    private let session: Session
    
    private init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }
    
    func fetch<Router, T>(api: Router, responseType: T.Type) async throws -> T where Router : TargetType, T : Decodable {
        guard let request = try? session.request(api.asURLRequest()) else {
            throw NetworkError.invalidRequest
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            request
                .validate(statusCode: 200...200)
                .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure:
                    if let data = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            continuation.resume(throwing: errorResponse)
                        } catch {
                            print(response.response?.statusCode)
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(throwing: NetworkError.noResponse)
                    }
                }
            }
        }
    }
    
    func fetchVoid<Router>(api: Router) async throws where Router : TargetType {
        guard let request = try? session.request(api.asURLRequest()) else {
            throw NetworkError.invalidRequest
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            request
                .validate(statusCode: 200...200)
                .response { response in
                switch response.result {
                case .success:
                    continuation.resume()
                case .failure:
                    if let data = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            continuation.resume(throwing: errorResponse)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(throwing: NetworkError.noResponse)
                    }
                }
            }
        }
    }
    
    enum NetworkError: Error {
        case invalidRequest
        case noResponse
    }
}
