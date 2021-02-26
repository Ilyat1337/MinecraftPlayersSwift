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
    @Published var avatarImage = Image("Steve")
    
    var avatarService = AvatarService()
    
    func nicknameTextFieldCommit(nickname: String) {
        print("Commit!!")
        avatarService.cancel()
        avatarService.loadAvatarForNickname(nickname: nickname) { imageData in
            print("Received!!!")
            self.avatarImage = Image(uiImage: UIImage(data: imageData)!)
        }
    }
}
