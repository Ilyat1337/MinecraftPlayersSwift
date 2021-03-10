//
//  PlayersRepository.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PlayersRepository {
    func getAll(completion: @escaping ([Player]?, Error?) -> Void)
    func add(_ player: Player, completion: @escaping (Error?) -> Void)
    func update(_ player: Player, completion: @escaping (Error?) -> Void)
}

class FirebasePlayersRepository: PlayersRepository {
    private let path = "players"

    private lazy var playersRef = Firestore.firestore().collection(path)

    func getAll(completion: @escaping ([Player]?, Error?) -> Void) {
        playersRef.getDocuments() { querySnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let players = querySnapshot?.documents.compactMap { documnent in
                try? documnent.data(as: Player.self)
            } ?? []
            completion(players, nil)
        }
    }

    func add(_ player: Player, completion: @escaping (Error?) -> Void) {
        do {
            _ = try playersRef.document(player.id!).setData(from: player)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func update(_ player: Player, completion: @escaping (Error?) -> Void) {
        do {
            _ = try playersRef.document(player.id!).setData(from: player)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
