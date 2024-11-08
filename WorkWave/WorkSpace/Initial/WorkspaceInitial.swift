//
//  WorkSpaceInitial.swift
//  WorkWave
//
//  Created by 조규연 on 11/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkspaceInitial {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case exitButtonTapped
    }
}
