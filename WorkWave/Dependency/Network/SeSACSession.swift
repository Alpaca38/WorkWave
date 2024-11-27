//
//  SeSACSession.swift
//  WorkWave
//
//  Created by 조규연 on 11/30/24.
//

import Foundation
import Alamofire

let SSAC = SesacSession.shared

final class SesacSession: Session {
    
    static let shared: SesacSession = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = NetworkPolicy.defaultTimeoutInterval
        return .init(configuration: configuration, interceptor: Interceptor(adapters: [NetworkingBaseAdapter()]), eventMonitors: [])
    }()
    
    func accessTokenRequest(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = AuthInterceptor()) -> DataRequest {
        return request(convertible, interceptor: interceptor)
    }
    
    func accessTokenRequest(_ convertible: URLConvertible, interceptor: RequestInterceptor? = AuthInterceptor()) -> DataRequest {
        return request(convertible, interceptor: interceptor)
    }
}

enum NetworkPolicy {
    static let defaultTimeoutInterval = 10.0
}
