//
//  PlayersService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/1/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import SwiftUI

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
            
            let avatarIds = players!.map { $0.avatarId }
            guard let players = players else { return }
            var playersMap: [String: Player] = [:]
            players.forEach { playersMap[$0.avatarId] = $0 }
            self.mediaRepository.loadAvatars(avatarIds: avatarIds) { imagesData, error in
                for imageData in imagesData {
                    playersMap[imageData.id]?.avatarImage = Image(uiImage: UIImage(data: imageData.data)!)
                }
                
                completion(players, nil)
            }
        }
    }
}

class ArrayPlayersService: PlayersService {
    func loadAllPlayers(completion: @escaping ([Player], Error?) -> Void) {
        completion(Array(repeating: 0, count: 5).map { number in
                    return getPlayerForPreview() }, nil)
    }
    

}


