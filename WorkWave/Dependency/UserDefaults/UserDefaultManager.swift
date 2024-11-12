//
//  UserDefaultManager.swift
//  WorkWave
//
//  Created by 조규연 on 11/11/24.
//

import Foundation

enum UserDefaultsManager {
    @UserDefault(key: .user, defaultValue: User(nickname: "Guest", email: "Guest@guest.com", phoneNumber: ""), isCustomObject: true)
    static var user: User
    
    @UserDefault(key: .isSignedUp, defaultValue: false, isCustomObject: false)
    static var isSignedUp: Bool
}
