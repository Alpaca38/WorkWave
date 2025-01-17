//
//  ImageClient.swift
//  WorkWave
//
//  Created by 조규연 on 1/9/25.
//

import Foundation
import UIKit
import ComposableArchitecture

@DependencyClient
struct ImageClient {
    var networkManager: NetworkManager
    var fetchImage: @Sendable (String) async throws -> UIImage
}

extension ImageClient: DependencyKey {
    static let liveValue = Self(
        networkManager: DefaultNetworkManager.shared,
        fetchImage: { [networkManager = DefaultNetworkManager.shared] path in
            do {
                return try await networkManager.requestImage(ImageRouter.fetchImage(path: path))
            } catch let error as ErrorResponse {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var imageClient: ImageClient {
        get { self[ImageClient.self] }
        set { self[ImageClient.self] = newValue }
    }
}
