//
//  PlayerEditViewModel.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/9/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import MapKit

struct ImageData {
    var image: UIImage
    var imageId: String?
}

class PlayerEditViewModel: ObservableObject{
    private var playersRepository: PlayersRepository
    private var mediaRepository: MediaRepository
    
    private var deletedImages: [String] = []
    
    private var player: Binding<Player>!
        
    @Published var nickname: String = ""
    @Published var occupation: Player.OccupationType = Player.OccupationType.survival
    @Published var favouriteMob: Player.MobType = Player.MobType.creeper
    
    @Published var favouriteServerAddress: String = ""
    @Published var privilege: Player.PrivilegeType = Player.PrivilegeType.player
    
    @Published var realworldName: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var age: String = ""
    
    @Published var latitude = ""
    @Published var longitude = ""
    
    @Published var displayedImages: [ImageData] = []
    @Published var newVideoLocalURL: URL?
    @Published var isSavedVideoShouldBeDeleted = false
    @Published var isPlayerHasSavedVideo = false
    
    init(playersRepository: PlayersRepository, mediaRepository: MediaRepository) {
        self.playersRepository = playersRepository
        self.mediaRepository = mediaRepository
    }
    
    func onViewCreated(player: Binding<Player>){
        self.player = player
        
        isPlayerHasSavedVideo = player.wrappedValue.videoUrl != nil
        initializeState()
    }
    
    func handleUpdateAuthorButtonClick(){
        let imagesToLoadDataList = displayedImages
            .filter { $0.imageId == nil }
            .map { $0.image.pngData()! }
        
        mediaRepository.deleteUserImages(userId: player.wrappedValue.id!, imageIds: deletedImages) { [self] error in
            if handleCallbackError(error) { return }
            
            mediaRepository.uploadUserImages(userId: player.wrappedValue.id!, imagesData: imagesToLoadDataList){ (newImagesIds, error) in
                if handleCallbackError(error) { return }                
                
                fillMissingIds(newImagesIds: newImagesIds)
                
                if isSavedVideoShouldBeDeleted {
                    mediaRepository.deleteVideo(videoUrl: player.wrappedValue.videoUrl!) { error in
                        if handleCallbackError(error) { return }
                        uploadVideoAndUpdatePlayerData()
                    }
                } else {
                    uploadVideoAndUpdatePlayerData()
                }
            }
        }
    }
    
    private func fillMissingIds(newImagesIds: [String]){
        var currentImageIdIndex = 0
        for i in 0..<displayedImages.count {
            if displayedImages[i].imageId == nil {
                displayedImages[i].imageId = newImagesIds[currentImageIdIndex]
                currentImageIdIndex += 1
            }
        }
    }
    
    private func uploadVideoAndUpdatePlayerData(){
        if (newVideoLocalURL != nil) {
            do {
                let videoData = try Data(contentsOf: newVideoLocalURL!)
                mediaRepository.uploadUserVideo(userId: player.wrappedValue.id!, videoData: videoData) { [self] videoUrl, error in
                    if handleCallbackError(error) {return}
                   
                    saveUpdatedPlayer(newVideoUrl: videoUrl)
                }
            } catch {
                _ = handleCallbackError(error)
                print("Error uploading video")
                return
            }
        } else {
            saveUpdatedPlayer(newVideoUrl: nil)
        }
    }
    
    private func saveUpdatedPlayer(newVideoUrl: URL?){
        let newPlayer = createUpdatedPlayer(newVideoUrl: newVideoUrl)
        
        playersRepository.update(newPlayer) { [self] error in
            if handleCallbackError(error) { return }
            
            player.wrappedValue.update(player: newPlayer)
            
            print("Player has been updated")
            
            isPlayerHasSavedVideo = player.wrappedValue.videoUrl != nil
            deletedImages = []
            isSavedVideoShouldBeDeleted = false
            newVideoLocalURL = nil
        }
    }
    
    private func createUpdatedPlayer(newVideoUrl: URL?) -> Player {
        let imageIds = displayedImages.map { $0.imageId! }
        let images = displayedImages.map { $0.image }
        let location = (latitude != "" && longitude != "") ?
        CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!) : nil
        let videoUrl = (isSavedVideoShouldBeDeleted || player.wrappedValue.videoUrl == nil) ? newVideoUrl : player.wrappedValue.videoUrl
        
        return Player(id: player.wrappedValue.id, email: player.wrappedValue.email, password: player.wrappedValue.password, nickname: nickname, occupation: occupation, favouriteMob: favouriteMob, favouriteServerAddress: favouriteServerAddress, privilege: privilege, realworldName: realworldName, country: country, city: city, age: Int(age)!, location: location, avatarId: player.wrappedValue.avatarId, avatarImage: player.wrappedValue.avatarImage, imageIds: imageIds, images: images, videoUrl: videoUrl)
    }

    
    func handleRemoveImage(deletedImagesIndexes: IndexSet) {
        deletedImagesIndexes.forEach { deletedImageIndex in
            let imgData = displayedImages[deletedImageIndex]
            if let id = imgData.imageId {
                deletedImages.append(id)
            }
        }
        displayedImages.remove(atOffsets: deletedImagesIndexes)
    }
    
    func addImage(_ uiImage: UIImage) {
        displayedImages.append(ImageData(image: uiImage, imageId: nil))
    }
    
    func handleDeleteVideoButtonClick() {
        newVideoLocalURL = nil
        
        if player.wrappedValue.videoUrl != nil {
            isSavedVideoShouldBeDeleted = true
        }
    }
    
    private func initializeState() {
        nickname = player.wrappedValue.nickname
        occupation = player.wrappedValue.occupation
        favouriteMob = player.wrappedValue.favouriteMob
        favouriteServerAddress = player.wrappedValue.favouriteServerAddress
        privilege = player.wrappedValue.privilege
        realworldName = player.wrappedValue.realworldName
        country = player.wrappedValue.country
        city = player.wrappedValue.city
        age = String(player.wrappedValue.age)
        latitude = String(player.wrappedValue.location?.latitude ?? 0)
        longitude = String(player.wrappedValue.location?.longitude ?? 0)
        displayedImages = (0..<player.wrappedValue.imageIds.count).map { ImageData(image: player.wrappedValue.images![$0], imageId: player.wrappedValue.imageIds[$0]) }
    }
    
    private func handleCallbackError(_ error: Error?) -> Bool{
        if let error = error {
            print("--------- ERROR CALLBACK ------------")
            print(error.localizedDescription)
            return true
        }
        return false
    }
}

