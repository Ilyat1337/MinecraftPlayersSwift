//
//  PlayersViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/20/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class PlayersStore: ObservableObject {
    private var arePlayersLoaded = false
    @Published var players: [Player] = []
    
    private var playersService: PlayersService
    
    init(playersService: PlayersService) {
        self.playersService = playersService
    }
    
    func loadAllPlayers() {
        if !arePlayersLoaded {
            arePlayersLoaded = true
            print("Loading players")
            playersService.loadAllPlayers { players, error in
                self.players = players
            }
        }
    }
}

//For preview

func getLoadedPlayersStore() -> PlayersStore {
    let playersStore = PlayersStore(playersService: ArrayPlayersService())
    playersStore.loadAllPlayers()
    return playersStore
}

