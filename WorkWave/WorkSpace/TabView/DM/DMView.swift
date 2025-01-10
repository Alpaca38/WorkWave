//
//  DMView.swift
//  WorkWave
//
//  Created by 조규연 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct DMView: View {
    @Bindable var store: StoreOf<DM>
    
    var body: some View {
        Text("DM")
    }
}
