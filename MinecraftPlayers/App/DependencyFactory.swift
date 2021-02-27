//
//  ViewModelFactory.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/27/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation

class DependencyFactory {
    static let shared = DependencyFactory()
    
    private let authenticationService = FirebaseAuthenticationService()
    private let loggedUserStore = LoggedUserStore()
    private let settingsStore = SettingsStore()
    private let avatarService = AvatarService()
    private let playersRepository = FirebasePlayersRepository()
    private let mediaRepository = FirebaseMediaRepository()
    
    func getSettingsStore() -> SettingsStore {
        return settingsStore
    }
    
    func getLoggedUserStore() -> LoggedUserStore {
        return loggedUserStore
    }
    
    func getSignInViewModel() -> SignInViewModel {
        return SignInViewModel(authenticationService, loggedUserStore)
    }
    
    func getSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(authenticationService, avatarService, playersRepository, mediaRepository, loggedUserStore)
    }
    
    func getPlayersViewModel() -> PlayersViewModel {
        return getLoadedPlayersViewModel()
    }
}
