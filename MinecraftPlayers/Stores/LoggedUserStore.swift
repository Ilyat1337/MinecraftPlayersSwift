//
//  LoggedUserStore.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Combine
import Foundation

class LoggedUserStore: ObservableObject {
    let userIdKey = "user_id"
    
    @Published var userId: String {
        didSet {
            UserDefaults.standard.set(userId, forKey: userIdKey)
        }
    }
    
    init() {
        userId = UserDefaults.standard.string(forKey: userIdKey) ?? ""
    }
}

//For preview
func getResetLoggedUserStore() -> LoggedUserStore {
    let loggedUserStore = LoggedUserStore()
    loggedUserStore.userId = ""
    return loggedUserStore
}
