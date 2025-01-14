//
//  UserDefaultManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/11/24.
//

import Foundation

enum UserDefaultsManager {
    @UserDefault(key: .user, defaultValue: User(userID: "GuestID", nickname: "Guest", email: "Guest@guest.com", phoneNumber: ""), isCustomObject: true)
    static var user: User
    
    @UserDefault(key: .isSignedUp, defaultValue: false, isCustomObject: false)
    static var isSignedUp: Bool
    
    @UserDefault(key: .workspaceID, defaultValue: "", isCustomObject: false)
    static var workspaceID: String
    
    static func saveWorkspaceID(_ workspaceID: String) {
        UserDefaultsManager.workspaceID = workspaceID
    }
    
    static func clearUserDefaults() {
        UserDefaultsManager.user = User(userID: "GuestID", nickname: "Guest", email: "Guest@guest.com", phoneNumber: "")
        UserDefaultsManager.isSignedUp = false
        UserDefaultsManager.workspaceID = ""
    }
}
