//
//  ImagePicker.swift
//  WorkWave
//
//  Created by 조규연 on 11/28/24.
//

import Foundation
import ComposableArchitecture
import PhotosUI

@Reducer
struct ImagePicker {
    @ObservableState
    struct State: Equatable {
        var configuration: PHPickerConfiguration {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            return config
        }
        var isPresented = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case presented(Bool)
        
        case imageSelected(Data?)
        case dismiss
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .presented(isPresented):
                state.isPresented = isPresented
                return .none
            case .imageSelected:
                return .none
            case .dismiss:
                return .none
            }
        }
    }
}
