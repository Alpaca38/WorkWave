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
    }
    
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
                } else if state.imageData == nil {
                    state.toast = ToastState(toastMessage: "워크스페이스 이미지를 등록해주세요.", isToastPresented: true)
                }
                return .none
            }
        }
        .ifLet(\.imagePickerState, action: \.imagePicker) {
            ImagePicker()
        }
    }
}
