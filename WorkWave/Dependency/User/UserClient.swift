//
//  UserClient.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct UserClient {
    var networkManager: NetworkManager
    var checkEmailValid: @Sendable (ValidationEmailRequest) async throws -> Void
    var signup: @Sendable (SignupRequest) async throws -> SignupDTO
    var login: @Sendable (LoginRequest) async throws -> SignupDTO
    var fetchMyProfile: @Sendable () async throws -> MyProfileResponse
    var editMyProfileImage: @Sendable (EditMyProfileImageRequest) async throws -> EditMyProfileResponse
}

extension UserClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        checkEmailValid: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                let _ = try await networkManager.requestWithoutResponse(api: UserRouter.checkEmailValid(query: request))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        signup: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: UserRouter.signup(query: request))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        login: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: UserRouter.login(query: request))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        fetchMyProfile: { [networkManager = DefaultNetworkManager.shared] in
            do {
                return try await networkManager.request(api: UserRouter.fetchMyProfile)
            } catch let error as ErrorResponse {
                throw error
            }
        },
        editMyProfileImage: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: UserRouter.editMyProfileImage(body: request))
            } catch let error as ErrorResponse {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
