//
//  Player.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Player: Identifiable, Codable {
    enum OccupationType: String, CaseIterable, Codable {
        case survival = "Survival"
        case redstone = "Redstone"
        case building = "Building"
        case pvp = "PvP"
        case mapArt = "Map art"
        case speedrun = "Speedrun"
        case hardcore = "Hardcore"
    }
    
    enum PrivilegeType: String, CaseIterable, Codable {
        case player = "Player"
        case moderator = "Moderator"
        case admin = "Admin"
        case vip = "VIP"
        case vipPlus = "VIP+"
        case mvp = "MVP"
        case mvpPlus = "MVP+"
    }
    
    enum MobType: String, CaseIterable, Codable {
        case creeper = "Creeper"
        case zombie = "Zombie"
        case skeleton = "Skeleton"
        case spider = "Spider"
        case enderman = "Enderman"
        case blaze = "Blaze"
    }
    
    @DocumentID var id = UUID().uuidString
    
    var email: String
    var password: String
    
    var nickname: String
    var occupation: OccupationType
    var favouriteMob: MobType
    
    var favouriteServerAddress: String
    var privilege: PrivilegeType
    
    var realworldName: String
    var country: String
    var city: String
    var age: Int
    
    @ExplicitNull
    var avatarUrl: URL?
    
    var image: Image {
        get { return Image("Steve") }
    }
}

let testData = Array(repeating:
                        Player(email: "IlyaNotFound@enail.com", password: "1qazxsw2", nickname: "IlyaNotFound", occupation: .mapArt, favouriteMob: .enderman, favouriteServerAddress: "mc.hypixel.net", privilege: .vipPlus, realworldName: "Ilya Trapashko", country: "Belarus", city: "Minsk", age: 19),
                     count: 5)

