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
        case slime = "Slime"
        case magmaCube = "Magma cube"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, email, password, nickname, occupation, favouriteMob, favouriteServerAddress, privilege, realworldName, country, city, age, avatarId, imageIds, videoUrl
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
    
    var imageIds: [String] = []
    var images: [Image]?
    
    var videoUrl: URL?
    
//    init(id: String, email: String, password: String, nickname: String, occupation: Player.OccupationType, favouriteMob: Player.MobType, favouriteServerAddress: String, privilege: Player.PrivilegeType, realworldName: String, country: String, city: String, age: Int, avatarId: String) {
//        self.id = id
//        self.email = email
//        self.password = password
//        self.nickname = nickname
//        self.occupation = occupation
//        self.favouriteMob = favouriteMob
//        self.favouriteServerAddress = favouriteServerAddress
//        self.privilege = privilege
//        self.realworldName = realworldName
//        self.country = country
//        self.city = city
//        self.age = age
//        self.avatarId = avatarId
//    }
    
    mutating func setImages(images: [Image]) {
        self.images = images
    }
    
    mutating func update(player: Player) {
        self = player
    }
}

//For preview

func getPlayerForPreview() -> Player {
    return Player(id: UUID().uuidString, email: "IlyaNotFound@enail.com", password: "123456", nickname: "IlyaNotFound", occupation: .mapArt, favouriteMob: .enderman, favouriteServerAddress: "mc.hypixel.net", privilege: .vipPlus, realworldName: "Ilya Trapashko", country: "Belarus", city: "Minsk", age: 19, location: CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893), avatarId: "", imageIds: ["test"], images: [Image("Steve"), Image("Creeper"), Image("Skeleton"), Image("Blaze"), Image("Zombie")], videoUrl: URL(string: "https://bit.ly/swswift"))//"https://www.youtube.com/watch?v=I-sH53vXP2A"))
}
