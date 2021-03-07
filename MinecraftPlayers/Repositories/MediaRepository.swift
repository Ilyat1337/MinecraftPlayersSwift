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
    func loadAvatars(avatarIds: [String], completion: @escaping ([LoadedMedia], Error?) -> Void)
    func loadUserGallery(userId: String, imageIds: [String], completion: @escaping ([LoadedMedia], Error?) -> Void)
    func uploadUserImages(userId: String, imagesData: [Data], completion: @escaping ([String], Error?) -> Void)
    func deleteUserImages(userId: String, imageIds: [String], completion: @escaping (Error?) -> Void)
    func uploadUserVideo(userId: String, videoData: Data, completion: @escaping (URL?, Error?) -> Void)
}

class FirebaseMediaRepository: MediaRepository {
    private let maxImageSize: Int64 = 1024 * 1024
    
    private let avatarsPath = "avatars"
    private lazy var avatarsRef = Storage.storage().reference(withPath: avatarsPath)
    private let galleryPath = "gallery"
    private let videosPath = "videos"
    
    func uploadAvatar(avatarData: Data, completion: @escaping (String?, Error?) -> Void) {
        let loadedAvatar = LoadedMedia(UUID().uuidString, avatarData)
        let avatarRef = avatarsRef.child(loadedAvatar.id)
        uploadMedia(direcoryRef: avatarRef, loadedMedia: loadedAvatar) { avatarId, error in
            completion(loadedAvatar.id, error)
        }
    }
    
    func loadAvatars(avatarIds: [String], completion: @escaping ([LoadedMedia], Error?) -> Void) {
        waitForAllTasks(directoryRef: avatarsRef, tasksData: avatarIds, task: downloadMedia) { (imagesData, error) in
            completion(imagesData, error)
        }
    }
    
    func loadUserGallery(userId: String, imageIds: [String], completion: @escaping ([LoadedMedia], Error?) -> Void) {
        let galleryRef = getUserGalleryRef(userId: userId)
        waitForAllTasks(directoryRef: galleryRef, tasksData: imageIds, task: downloadMedia) { (imagesInfo, error) in
            completion(imagesInfo, error)
        }
    }
    
    private func downloadMedia(directoryRef: StorageReference, medaiId: String,
               completion: @escaping (LoadedMedia?, Error?) -> Void) {
        directoryRef.child(medaiId).getData(maxSize: maxImageSize) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(LoadedMedia(medaiId, data!), nil)
        }
    }
    
    func uploadUserImages(userId: String, imagesData: [Data], completion: @escaping ([String], Error?) -> Void) {
        let loadedImages = imagesData.map { LoadedMedia(UUID().uuidString, $0) }
        let galleryRef = getUserGalleryRef(userId: userId)
        waitForAllTasks(directoryRef: galleryRef, tasksData: loadedImages, task: uploadMedia) { imageIds, error in
            completion(imageIds, error)
        }
    }
    
    private func uploadMedia(direcoryRef: StorageReference, loadedMedia: LoadedMedia,
             completion: @escaping (String?, Error?) -> Void) {
        direcoryRef.child(loadedMedia.id).putData(loadedMedia.data, metadata: nil) { metadata, error in
            completion(loadedMedia.id, error)
        }
    }
    
    func deleteUserImages(userId: String, imageIds: [String], completion: @escaping (Error?) -> Void) {
        let galleryRef = getUserGalleryRef(userId: userId)
        waitForAllTasks(directoryRef: galleryRef, tasksData: imageIds, task: deleteMedia) { void, error in
            completion(error)
        }
    }
    
    private func deleteMedia(direcoryRef: StorageReference, mediaId: String,
                 completion: @escaping (String?, Error?) -> Void) {
        direcoryRef.child(mediaId).delete { error in
            completion("", error)
        }
    }
    
    private func getUserGalleryRef(userId: String) -> StorageReference {
        return Storage.storage().reference().child(userId).child(galleryPath)
    }
    
    func uploadUserVideo(userId: String, videoData: Data, completion: @escaping (URL?, Error?) -> Void) {
        let videoId = UUID().uuidString
        let videoRef = Storage.storage().reference().child(userId).child(videosPath).child(videoId)
        videoRef.putData(videoData, metadata: nil) { metadata, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            videoRef.downloadURL { url, error in
                completion(url, error)
            }
        }
    }
    
    private func waitForAllTasks<TaskData, ReturnType>(directoryRef: StorageReference, tasksData: [TaskData],
               task: (StorageReference, TaskData, @escaping (ReturnType?, Error?) -> Void) -> Void, completion: @escaping ([ReturnType], Error?) -> Void) {
        if tasksData.isEmpty {
            completion([], nil)
        }
        
        var results = [ReturnType]()
        var taskCount = 0
        var isErrorOccured = false
        let lock = NSLock()
        
        for taskData in tasksData {
            task(directoryRef, taskData) { (returnValue, error) in
                if let error = error {
                    if !isErrorOccured {
                        isErrorOccured = true
                        completion(results, error)
                    }
                    return
                }
                
                lock.lock()
                
                results.append(returnValue!)
                taskCount += 1
                
                if taskCount == tasksData.count {
                    lock.unlock()
                    completion(results, nil)
                    return
                }
                
                lock.unlock()
            }
        }
    }
}
