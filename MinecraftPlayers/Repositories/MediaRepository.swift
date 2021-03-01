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
    func uploadAvatar(avatarData: Data, completion: @escaping (String?, Error?) -> Void)
    func loadAvatars(avatarIds: [String], completion: @escaping ([ImageData], Error?) -> Void)
}

class FirebaseMediaRepository: MediaRepository {
    private let maxImageSize: Int64 = 1024 * 1024
    
    private let avatarsPath = "avatars"
    private lazy var avatarsRef = Storage.storage().reference(withPath: avatarsPath)
    
    func uploadAvatar(avatarData: Data, completion: @escaping (String?, Error?) -> Void) {
        let avatarId = UUID().uuidString
        let avatarRef = avatarsRef.child(avatarId)
        avatarRef.putData(avatarData, metadata: nil) { metadata, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(avatarId, error)
        }
    }
    
    func loadAvatars(avatarIds: [String], completion: @escaping ([ImageData], Error?) -> Void) {
        self.downloadImageArray(directory: avatarsPath, imageIds: avatarIds) { (imageData, error) in
            completion(imageData, error)
        }
    }
    
    private func downloadImageArray(directory: String, imageIds: [String], completion: @escaping ([ImageData], Error?) -> Void) {
        let directoryRef = Storage.storage().reference(withPath: directory)
        
        var downloadedImages = [ImageData]()
        var downloadCount = 0
        var isErrorOccured = false
        var downloadTasks = [StorageDownloadTask]()
        let lock = NSLock()
        
        print("Loading images...")

        for imageId in imageIds {
            let imageRef = directoryRef.child(imageId)

            // Upload image to firebase
            let uploadTask = imageRef.getData(maxSize: maxImageSize) { (data, error) in
                if let error = error {
                    if !isErrorOccured {
                        isErrorOccured = true
                        completion(downloadedImages, error)
                    }
                    return
                }
                
                lock.lock()
                
                downloadedImages.append(ImageData(imageId, data!))
                downloadCount += 1
                
                print("\(downloadCount) images loaded")
                
                if downloadCount == imageIds.count {
                    lock.unlock()
                    completion(downloadedImages, nil)
                    return
                }
                
                lock.unlock()
            }
            downloadTasks.append(uploadTask)
        }
    }
}
