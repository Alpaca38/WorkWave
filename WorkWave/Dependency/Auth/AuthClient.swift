//
//  AuthClient.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct AuthClient {
    var networkManager: NetworkManager
    var refresh: @Sendable () async throws -> Refresh
}

extension AuthClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        refresh: { [networkManager = DefaultNetworkManager.shared] in
            do {
                return try await networkManager.request(api: AuthRouter.refresh)
            } catch let error as ErrorResponse {
                throw error
            }
        })
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
