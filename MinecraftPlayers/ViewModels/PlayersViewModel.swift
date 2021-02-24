//
//  PlayersViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/20/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Combine

class PlayersViewModel: ObservableObject {
    @Published var players: [Player] = []
    
    private var playersService: PlayersService
    
    init(_ playersService: PlayersService) {
        self.playersService = playersService
    }
    
    func loadAllPlayers() {
        players = playersService.getAllPlayers()
    }
}


//For preview
func getLoadedPlayersViewModel() -> PlayersViewModel {
    let playersViewModel = PlayersViewModel(ArrayPlayersService())
    playersViewModel.loadAllPlayers()
    return playersViewModel
}

