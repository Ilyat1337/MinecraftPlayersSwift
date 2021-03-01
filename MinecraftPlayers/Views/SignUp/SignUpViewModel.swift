//
//  SignUpViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/25/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class SignUpViewModel: ObservableObject {
    private var authenticationService: AuthenticationService
    private var avatarService: AvatarService
    private var playersRepository: PlayersRepository
    private var mediaRepository: MediaRepository
    private var loggedUserStore: LoggedUserStore
    
    @Published var avatarImage = Image("Steve")
    private var avatarData = UIImage(named: "Steve")!.pngData()!
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var nickname: String = ""
    @Published var occupation: Player.OccupationType = Player.OccupationType.survival
    @Published var favouriteMob: Player.MobType = Player.MobType.zombie
    
    @Published var favouriteServerAddress: String = ""
    @Published var privilege: Player.PrivilegeType = Player.PrivilegeType.player
    
    @Published var realworldName: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var age: String = ""
    
    @Published var isSigningUp = false
    @Published var showAlert = false
    var errorMessage = ""
    
    internal init(_ authenticationService: AuthenticationService, _ avatarService: AvatarService, _ playersRepository: PlayersRepository, _ mediaRepository: MediaRepository, _ loggedUserStore: LoggedUserStore) {
        self.authenticationService = authenticationService
        self.avatarService = avatarService
        self.playersRepository = playersRepository
        self.mediaRepository = mediaRepository
        self.loggedUserStore = loggedUserStore
    }
    
    func loadAvatarForNickname(nickname: String) {
        print("Commit!!")
        avatarService.cancel()
        avatarService.loadAvatarForNickname(nickname: nickname) { imageData in
            print("Received!!!")
            self.avatarData = imageData
            self.avatarImage = Image(uiImage: UIImage(data: imageData)!)
        }
    }
    
    func signUp() {
        avatarService.cancel()
        isSigningUp = true
        
        authenticationService.signUpWithEmail(email: email, password: password) { [self] userId, error  in
            if handleError(error: error) {
                return
            }

            mediaRepository.uploadAvatar(avatarData: avatarData) { avatarId, error in
                if handleError(error: error) {
                    return
                }

                guard let userId = userId else {
                    return
                }

                let player = Player(id: userId, email: email, password: password, nickname: nickname, occupation: occupation, favouriteMob: favouriteMob, favouriteServerAddress: favouriteServerAddress, privilege: privilege, realworldName: realworldName, country: country, city: city, age: Int(age) ?? 0, avatarId: avatarId!)

                playersRepository.add(player) { error in
                    if handleError(error: error) {
                        return
                    }

                    self.loggedUserStore.userId = userId
                }
            }
        }
    }
    
    private func handleError(error: Error?) -> Bool {
        if let error = error {
            errorMessage = error.localizedDescription
            showAlert = true
            isSigningUp = false
            return true
        }
        
        return false
    }
}
