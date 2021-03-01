//
//  ContentView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/23/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject private var loggedUserStore: LoggedUserStore
    @EnvironmentObject private var settings: SettingsStore
    
    var body: some View {
        VStack {
            if loggedUserStore.userId.isEmpty {
                SignInView(viewModel: DependencyFactory.shared.getSignInViewModel())
            }
            else {
                MainView()
            }
        }
        .animation(.spring())
        .environment(\.colorScheme, settings.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: DependencyFactory.shared.getSignInViewModel())
    }
}
