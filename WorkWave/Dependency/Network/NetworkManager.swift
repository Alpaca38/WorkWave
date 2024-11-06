//
//  NetworkManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/5/24.
//

import Foundation

protocol NetworkManager {
    func fetch<Router: TargetType, T: Decodable>(
        api: Router,
        responseType: T.Type
    ) async throws -> T
    
    func fetchVoid<Router: TargetType>(
        api: Router
    ) async throws
}
