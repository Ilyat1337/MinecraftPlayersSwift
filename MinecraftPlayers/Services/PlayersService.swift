//
//  PlayersService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/1/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

protocol PlayersService {
    func loadAllPlayers(completion: @escaping ([Player], Error?) -> Void)
}

class FirebasePlayersService: PlayersService {
    private let playersRepository: PlayersRepository
    private let mediaRepository: MediaRepository
    
    init(playersRepository: PlayersRepository, mediaRepository: MediaRepository) {
        self.playersRepository = playersRepository
        self.mediaRepository = mediaRepository
    }
    
    func loadAllPlayers(completion: @escaping ([Player], Error?) -> Void) {
        playersRepository.getAll { players, error in
            if error != nil {
                completion([], error)
                return
            }
            
            guard var players = players else { return }
            let avatarIds = players.map { $0.avatarId }
            self.mediaRepository.loadAvatars(avatarIds: avatarIds) { imagesData, error in
                for i in 0..<players.count {
                    let imageData = imagesData.first(where: { $0.id == players[i].avatarId })
                    if let imageData = imageData {
                        players[i].avatarImage = Image(uiImage: UIImage(data: imageData.data)!)
                    }
                }
                
                completion(players, nil)
            }
        }
    }
}

class ArrayPlayersService: PlayersService {
    func loadAllPlayers(completion: @escaping ([Player], Error?) -> Void) {
        var playersArray = Array(repeating: 0, count: 5).map { number in
            return getPlayerForPreview() }
        playersArray[0].location = CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893)
        playersArray[1].location = CLLocationCoordinate2D(latitude: 52.63, longitude: 30.91)
        playersArray[2].location = CLLocationCoordinate2D(latitude: 55.48, longitude: 30.15)
        playersArray[3].location = CLLocationCoordinate2D(latitude: 52.30, longitude: 23.83)
        playersArray[4].location = CLLocationCoordinate2D(latitude: 53.75, longitude: 23.77)
        completion(playersArray, nil)
    }
    

}


