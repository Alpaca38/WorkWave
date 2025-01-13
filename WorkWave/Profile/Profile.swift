//
//  Profile.swift
//  WorkWave
//
//  Created by 조규연 on 1/14/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Profile {
    enum ProfileType {
        case me
        case otherUser
    }
    
    @ObservableState
    struct State {
        let profileType: Profile.ProfileType
        var nickname: String
        var email: String
        var profileImage: String
        var phoneNumber: String
        
        var isProfileChanged: Bool {
            return selectedImage != nil || profileImage.isEmpty
        }
        var selectedImage: [UIImage]? = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case deleteProfileImage
        case phoneNumberTapped
        case logoutButtonTapped
        case saveButtonTapped
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .deleteProfileImage:
                state.selectedImage?.removeAll()
                state.profileImage = ""
                return .none
            case .phoneNumberTapped:
                return .none
            case .logoutButtonTapped:
                return .none
            case .saveButtonTapped:
                return .run { [state = state] send in
                    do {
                        guard let data = state.selectedImage?.last?.jpegData(
                            compressionQuality: 0.5
                        ) else {
                            print("No SelectedImage")
                            return
                        }
                        _ = try await userClient.editMyProfileImage(
                            EditMyProfileImageRequest(image: data)
                        )
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
