//
//  AuthInterceptor.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import ComposableArchitecture
import Alamofire

enum TokenError: Error {
    case missingAccessToken
    case missingRefreshToken
}

final class AuthInterceptor: RequestInterceptor {
    @Dependency(\.jwtKeyChain) var jwtKeyChain
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if let accessToken = jwtKeyChain.accessToken {
            request.headers.add(.authorization(accessToken))
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        if let afError = error.asAFError {
            if let slpError = afError.unwrap() as? SLPCommonError {
                if case .accessTokenTimeOut = slpError {
                    AccessTokenRefresher().excute(refreshToken: jwtKeyChain.refreshToken) { result in
                        switch result {
                        case .success(let success):
                            self.jwtKeyChain.updateAccessToken(accessToken: success)
                            completion(.retry)
                        case .failure(let failure):
                            completion(.doNotRetryWithError(failure))
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct AccessTokenRefresher {
    func excute(refreshToken: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let refreshToken else {
            completion(.failure(TokenError.missingRefreshToken))
            return
        }
        let header: HTTPHeaders = ["RefreshToken":refreshToken]
        SSAC.request("/v1/auth/refresh", headers: header).slpResponseDecodable(of: Refresh.self) { response in
            switch response.result {
            case .success(let dto):
                completion(.success(dto.accessToken))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

extension AFError {
    func unwrap() -> Error {
        var error = self
        while true {
            guard let underlyingError = error.underlyingError else { return error }
            if let under = underlyingError.asAFError {
                error = under
            } else {
                return underlyingError
            }
        }
    }
}
