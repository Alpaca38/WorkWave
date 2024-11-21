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
        case refreshResponse(Result<Refresh, ErrorResponse>)
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
            case let .workspaceResponse(.success(success)):
                state.workSpaceExist = !success.response.isEmpty
                return .none
            case let .workspaceResponse(.failure(error)):
                print(error.errorCode)
                switch error.errorCode {
                case "E05":
                    return .run { send in
                        do {
                            await send(.refreshResponse(.success(try await authClient.refresh())))
                        } catch let error as ErrorResponse {
                            await send(.refreshResponse(.failure(error)))
                        } catch {
                            print(error)
                        }
                    }
                default:
                    return .none
                }
            case .refreshResponse(.success):
                return .run { send in
                    await send(.checkWorkspaceExist)
                }
            case .refreshResponse(.failure):
                print("재로그인이 필요합니다.")
                UserDefaultsManager.isSignedUp = false
                return .none
            }
        }
    }
}
