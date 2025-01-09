//
//  WorkspaceAdd.swift
//  WorkWave
//
//  Created by 조규연 on 11/12/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkspaceAdd {
    @ObservableState
    struct State: Equatable {
        var workspaceName = ""
        var workspaceDescription = ""
        var completeButtonValid = false
        
        var toast: ToastState = ToastState(toastMessage: "", isToastPresented: false)
        
        var imagePickerState: ImagePicker.State?
        var imageData: Data?
        var isImagePickerPresented = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case imageTapped(isPresented: Bool)
        case imagePicker(ImagePicker.Action)
        case completeButtonTapped
        case addworkspaceResponse(Result<WorkspaceDTO.ResponseElement, ErrorResponse>)
    }
    
    @Dependency(\.workspaceClient) var workspaceClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                state.completeButtonValid = !state.workspaceName.isEmpty
                return .none
            case .exitButtonTapped:
                return .none
            case .imageTapped(isPresented: true):
                state.isImagePickerPresented = true
                state.imagePickerState = ImagePicker.State()
                return .none
            case .imageTapped(isPresented: false):
                state.isImagePickerPresented = false
                state.imagePickerState = nil
                return .none
            case let .imagePicker(.imageSelected(data)):
                state.imageData = data
                state.imagePickerState = nil
                return .none
            case .imagePicker(.dismiss):
                state.imagePickerState = nil
                return .none
            case .imagePicker:
                return .none
            case .completeButtonTapped:
                if state.workspaceName.count > 30 {
                    state.toast = ToastState(toastMessage: "워크스페이스 이름은 1~30자로 설정해주세요.", isToastPresented: true)
                    return .none
                } else if state.imageData == nil {
                    state.toast = ToastState(toastMessage: "워크스페이스 이미지를 등록해주세요.", isToastPresented: true)
                    return .none
                } else {
                    let request = AddWorkspaceRequest(name: state.workspaceName, description: state.workspaceDescription, image: state.imageData)
                    return .run { send in
                        do {
                            await send(.addworkspaceResponse(.success(try await workspaceClient.addWorkspace(request))))
                        } catch let error as ErrorResponse {
                            await send(.addworkspaceResponse(.failure(error)))
                        } catch {
                            throw error
                        }
                    }
                }
            case let .addworkspaceResponse(.success(workspace)):
                // 생성 성공, 홈 디폴트 화면으로 전환
                print(workspace)
                return .run { send in
                    await dismiss()
                }
            case let .addworkspaceResponse(.failure(error)):
                print("워크스페이스 생성 실패", error)
                return .none
            }
        }
        .ifLet(\.imagePickerState, action: \.imagePicker) {
            ImagePicker()
        }
    }
}
