//
//  MediaService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/27/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation
import Firebase

protocol MediaRepository {
    func uploadAvatar(avatarData: Data, completion: @escaping (URL?, Error?) -> Void)
}

class FirebaseMediaRepository: MediaRepository {
    private let avatarsPath = "avatars"
    private lazy var avatarsRef = Storage.storage().reference(withPath: avatarsPath)
    
    func uploadAvatar(avatarData: Data, completion: @escaping (URL?, Error?) -> Void) {
        let avatarRef = avatarsRef.child(UUID().uuidString)
        avatarRef.putData(avatarData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            avatarRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(url!, nil)
            }
        }
    }
}
