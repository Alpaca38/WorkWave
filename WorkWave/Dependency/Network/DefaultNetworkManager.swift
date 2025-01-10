//
//  DefaultNetworkManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/6/24.
//

import Foundation
import Alamofire
import ComposableArchitecture

final class DefaultNetworkManager: NetworkManager {
    static let shared = DefaultNetworkManager()
    private let session: Session
    
    private init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.jwtKeyChain) var jwtKeyChain
    
    /// 데이터가 필요한 요청
    func request<Router: TargetType, ModelType: Decodable>(
        api: Router
    ) async throws -> ModelType {
        let data = api.multipartData == nil ?
                   try await performRequest(api: api) :
                   try await performMultipartRequest(api: api)
        return try handleResponse(data: data, api: api)
    }
    
    /// 응답 데이터가 필요 없는 요청
    func requestWithoutResponse<Router: TargetType>(api: Router) async throws {
        _ = try await performRequest(api: api)
    }
    
    private func requestWithMultipart<Router: TargetType, ModelType: Decodable>(
        api: Router
    ) async throws -> ModelType {
        let data = try await performMultipartRequest(api: api)
        return try handleResponse(data: data, api: api)
    }
    
    private func handleResponse<T: Decodable>(
        data: Data?,
        api: any TargetType
    ) throws -> T {
        guard let data = data else {
            throw NetworkError.unknown
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("\(api) 모델 디코딩 실패")
            throw NetworkError.unknown
        }
    }
    
    private func handleError(
        response: Data?,
        api: any TargetType
    ) async throws -> Error {
        do {
            let errorData = try JSONDecoder().decode(
                ErrorResponse.self,
                from: response ?? Data()
            )
            print("\(api) 에러 \(errorData.errorCode)")
            
            if errorData.errorCode == "E05" {
                return try await handleTokenRefresh(errorData: errorData)
            }
            return errorData
        } catch {
            print("\(api) 에러 모델 디코딩 실패")
            return NetworkError.unknown
        }
    }
    
    private func handleTokenRefresh(errorData: ErrorResponse) async throws -> Error {
        do {
            let result: Token = try await request(api: AuthRouter.refresh)
            jwtKeyChain.updateAccessToken(accessToken: result.accessToken)
            return errorData
        } catch {
            print("토큰 갱신 에러")
            jwtKeyChain.clearTokens()
            return error
        }
    }
    
    private func performRequest<Router: TargetType>(api: Router) async throws -> Data? {
        let request = try api.asURLRequest()
        let response = await AF.request(request).serializingData().response
        return try await handleStatusCode(response: response, api: api)
    }
    
    private func performMultipartRequest<Router: TargetType>(
        api: Router
    ) async throws -> Data? {
        let request = try api.asURLRequest()
        let response = await AF.upload(
            multipartFormData: { multipartFormData in
                // 일반 파라미터 추가
                if let parameters = api.parameters {
                    for (key, value) in parameters {
                        let data = Data("\(value)".utf8)
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                // 멀티파트 데이터 추가
                if let multipartDatas = api.multipartData {
                    for item in multipartDatas {
                        multipartFormData.append(
                            item.data,
                            withName: item.name,
                            fileName: item.fileName,
                            mimeType: item.mimeType
                        )
                    }
                }
            },
            with: request
        ).serializingData().response
        
        return try await handleStatusCode(response: response, api: api)
    }
    
    private func handleStatusCode(
        response: AFDataResponse<Data>,
        api: any TargetType
    ) async throws -> Data? {
        let statusCode = response.response?.statusCode ?? 0
        
        switch statusCode {
        case 200:
            print("\(api) 성공")
            return response.data
            
        case 400, 500:
            let error = try await handleError(response: response.data, api: api)
            
            // 토큰 만료 에러인 경우 요청 재시도
            if let errorResponse = error as? ErrorResponse,
               errorResponse.errorCode == "E05" {
                if api.multipartData != nil {
                    return try await performMultipartRequest(api: api)
                } else {
                    return try await performRequest(api: api)
                }
            }
            throw error
            
        default:
            print("\(api) 알 수 없는 에러")
            throw NetworkError.unknown
        }
    }
}

enum NetworkError: Error {
    case invalidRequest
    case noResponse
    case unknown
}
