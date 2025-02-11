//
//  Home.swift
//  WorkWave
//
//  Created by 조규연 on 11/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WWTab {
    @ObservableState
    struct State: Equatable {
        var workSpaceExist = false
    }
    
    enum Action {
        case checkWorkspaceExist
        case workspaceResponse(Result<WorkspaceDTO.Response, ErrorResponse>)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkWorkspaceExist:
                return .run { send in
                    do {
                        await send(.workspaceResponse(.success(try await workspaceClient.getWorkspaceList())))
                    } catch let error as ErrorResponse {
                        await send(.workspaceResponse(.failure(error)))
                    } catch {
                        print(error)
                    }
                }
            case .workspaceResponse(.success(let success)):
                state.workSpaceExist = !success.isEmpty
                return .none
            case .workspaceResponse(.failure(let error)):
                print(error.errorCode)
                return .none
            }
        }
    }
}
