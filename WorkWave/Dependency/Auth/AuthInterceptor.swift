//
//  AuthInterceptor.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import ComposableArchitecture
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    @Dependency(\.jwtKeyChain) var jwtKeyChain
    @Dependency(\.authClient) var authClient
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if let accessToken = jwtKeyChain.accessToken {
            request.setValue(accessToken, forHTTPHeaderField: Header.authorization.rawValue)
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let error = error as? ErrorResponse, error.errorCode == "E05" else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            do {
                let refreshResponse = try await authClient.refresh()
                jwtKeyChain.updateAccessToken(accessToken: refreshResponse.accessToken)
                completion(.retry)
            } catch let error as ErrorResponse {
                if error.errorCode == "E06" {
                    print("다시 로그인")
                }
                UserDefaultsManager.isSignedUp = false
                completion(.doNotRetryWithError(error))
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
