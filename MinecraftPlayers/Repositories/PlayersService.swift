//
//  PlayersService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation

protocol PlayersService {
    func getAllPlayers() -> [Player]
    func updatePlayer(player: Player)
}

class ArrayPlayersService: PlayersService {
    var players = Array(repeating: 0, count: 8).map { (Int) -> Player in
        return Player(email: "IlyaNotFound@enail.com", password: "1qazxsw2", nickname: "IlyaNotFound", occupation: .mapArt, favouriteMob: .enderman, favouriteServerAddress: "mc.hypixel.net", privilege: .vipPlus, realworldName: "Ilya Trapashko", country: "Belarus", city: "Minsk", age: 19) }
    
    func getAllPlayers() -> [Player] {
        return players
    }
    
    func updatePlayer(player: Player) {
        
    }

}
