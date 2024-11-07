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
}

extension UserClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        checkEmailValid: { request in
            do {
                let _ = try await DefaultNetworkManager.shared.fetchVoid(api: UserRouter.checkEmailValid(query: request))
            } catch let error as ErrorResponse {
                throw error
            }
        },
        signup: { request in
            do {
                return try await DefaultNetworkManager.shared.fetch(api: UserRouter.signup(query: request), responseType: SignupDTO.self)
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
