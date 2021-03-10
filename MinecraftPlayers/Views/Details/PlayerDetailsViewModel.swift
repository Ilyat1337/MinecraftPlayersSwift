//
//  PlayerDetailsViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/6/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class PlayerDetailsViewModel: ObservableObject {
    @Published var player: Binding<Player>!
    
    private let mediaRepository: MediaRepository
    
    internal init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }
    
    func setPlayer(player: Binding<Player>) {
        self.player = player
    }
    
    func loadPlayerGallery() {
        if player.images.wrappedValue == nil {
            if player.imageIds.wrappedValue.isEmpty {
                player.images.wrappedValue = []
                return
            }
            
            mediaRepository.loadUserGallery(userId: player.id.wrappedValue!, imageIds: player.imageIds.wrappedValue) { loadedImages, error in
                let images = loadedImages.map { UIImage(data: $0.data)! }
                DispatchQueue.main.async {
                    self.player.images.wrappedValue = images
                }
            }
        }
    }
}
