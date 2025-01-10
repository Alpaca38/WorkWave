//
//  NetworkManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation

protocol NetworkManager {
    func request<Router: TargetType, ModelType: Decodable>(
        api: Router
    ) async throws -> ModelType
    
    func requestWithoutResponse<Router: TargetType>(api: Router) async throws
}
