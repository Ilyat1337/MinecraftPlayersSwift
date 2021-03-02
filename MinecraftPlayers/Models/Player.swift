//
//  Player.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

class Player: Identifiable, Codable {
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
    
    private enum CodingKeys: String, CodingKey {
        case id, email, password, nickname, occupation, favouriteMob, favouriteServerAddress, privilege, realworldName, country, city, age, avatarId
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
    
    var location: CLLocationCoordinate2D?
    
    var avatarId: String = ""
    var avatarImage: Image = Image("Steve")
    
    init(id: String, email: String, password: String, nickname: String, occupation: Player.OccupationType, favouriteMob: Player.MobType, favouriteServerAddress: String, privilege: Player.PrivilegeType, realworldName: String, country: String, city: String, age: Int, avatarId: String) {
        self.id = id
        self.email = email
        self.password = password
        self.nickname = nickname
        self.occupation = occupation
        self.favouriteMob = favouriteMob
        self.favouriteServerAddress = favouriteServerAddress
        self.privilege = privilege
        self.realworldName = realworldName
        self.country = country
        self.city = city
        self.age = age
        self.avatarId = avatarId
    }
}

//For preview

func getPlayerForPreview() -> Player {
    return Player(id: UUID().uuidString, email: "IlyaNotFound@enail.com", password: "1qazxsw2", nickname: "IlyaNotFound", occupation: .mapArt, favouriteMob: .enderman, favouriteServerAddress: "mc.hypixel.net", privilege: .vipPlus, realworldName: "Ilya Trapashko", country: "Belarus", city: "Minsk", age: 19, avatarId: "")
}

let testData = Array(repeating: getPlayerForPreview(), count: 5)

