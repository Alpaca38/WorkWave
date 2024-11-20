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
        case workspaceResponse(Result<WorkspaceDTO, ErrorResponse>)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    
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
            case let .workspaceResponse(.success(success)):
                state.workSpaceExist = !success.response.isEmpty
                return .none
            case let .workspaceResponse(.failure(error)):
                print(error.errorCode)
                return .none
            }
        }
    }
}
