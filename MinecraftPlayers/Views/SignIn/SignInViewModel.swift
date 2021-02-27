//
//  SignInViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    private var authenticationService: AuthenticationService
    private var loggedUserStore: LoggedUserStore
    
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var showSignUpView = false
    var errorMessage = ""
    
    init(_ authenticationService: AuthenticationService, _ loggedUserStore: LoggedUserStore) {
        self.authenticationService = authenticationService
        self.loggedUserStore = loggedUserStore
    }
    
    func signIn() {
        authenticationService.signInWithEmail(email: email, password: password) { userId, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            if let userId = userId {
                self.loggedUserStore.userId = userId
            }
        }
    }
}
