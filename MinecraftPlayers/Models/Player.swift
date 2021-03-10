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
        
        func getColor() -> Color {
            switch self {
            case .admin:
                return Color.red
            case .vip, .vipPlus:
                return Color(red: 85 / 255, green: 1, blue: 85 / 255)
            case .mvp, .mvpPlus:
                return Color(red: 85 / 255, green: 1, blue: 1)
            default:
                return Color.black
            }
        }
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
        case id, email, password, nickname, occupation, favouriteMob, favouriteServerAddress, privilege, realworldName, country, city, age, avatarId, imageIds, videoUrl, location
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
    var images: [UIImage]?
    
    var videoUrl: URL?
    
    mutating func update(player: Player) {
        self = player
    }
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitude = try container.decode(CLLocationDegrees.self)
        let longitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

//For preview

func getPlayerForPreview() -> Player {
    return Player(id: UUID().uuidString, email: "IlyaNotFound@enail.com", password: "123456", nickname: "IlyaNotFound", occupation: .mapArt, favouriteMob: .enderman, favouriteServerAddress: "mc.hypixel.net", privilege: .vipPlus, realworldName: "Ilya Trapashko", country: "Belarus", city: "Minsk", age: 19, location: CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893), avatarId: "", imageIds: ["test"], images: [UIImage(named: "Steve")!, UIImage(named: "Creeper")!, UIImage(named: "Skeleton")!, UIImage(named: "Blaze")!, UIImage(named: "Zombie")!], videoUrl: URL(string: "https://bit.ly/swswift"))//"https://www.youtube.com/watch?v=I-sH53vXP2A"))
}
