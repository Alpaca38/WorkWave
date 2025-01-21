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
    var appleLogin: @Sendable (AppleLoginRequest) async throws -> SignupDTO
    var fetchMyProfile: @Sendable () async throws -> MyProfileResponse
    var editMyProfile: @Sendable (EditMyProfileRequest) async throws -> EditMyProfileResponse
    var editMyProfileImage: @Sendable (EditMyProfileImageRequest) async throws -> EditMyProfileResponse
    var fetchOthersProfile: @Sendable (String) async throws -> MemberResponse
    var logout: @Sendable () async throws -> Void
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
        appleLogin: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: UserRouter.appleLogin(body: request))
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
        editMyProfile: { [networkManager = DefaultNetworkManager.shared] request in
            do {
                return try await networkManager.request(api: UserRouter.editMyProfile(body: request))
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
        },
        fetchOthersProfile: { [networkManager = DefaultNetworkManager.shared] userID in
            do {
                return try await networkManager.request(api: UserRouter.fetchOthersProfile(userID: userID))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        logout: { [networkManager = DefaultNetworkManager.shared] in
            do {
                return try await networkManager.requestWithoutResponse(api: UserRouter.logout)
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
