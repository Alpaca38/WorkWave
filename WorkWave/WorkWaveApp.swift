//
//  WorkWaveApp.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct WorkWaveApp: App {
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) private var appDelegate
    
    init() {
        ImageFileManager.shared.createDirectory()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear {
                appDelegate.deviceKeyChain = DeviceTokenKeyChain()
            }
        }
    }
}
