//
//  PlayerDetails.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import AVKit

fileprivate struct DetailRow<T>: View where T: View {
    var leftText: String
    var rightView: T
    
    init(_ leftText: String, _ rightView: T) {
        self.leftText = leftText
        self.rightView = rightView
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(leftText)
                .bold()
            Spacer()
            rightView
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct PlayerDetails: View {
    static let previewImageCount = 3
    let layout = Array(repeating: GridItem(.flexible()), count: previewImageCount + 1)

    @EnvironmentObject private var settings: SettingsStore
    @State var isShowingGallery = false
    @ObservedObject var viewModel: PlayerDetailsViewModel
    @Binding var player: Player
    
    
    init(viewModel: PlayerDetailsViewModel, player: Binding<Player>) {
        self.viewModel = viewModel
        self._player = player
        viewModel.setPlayer(player: player)
    }
    
    var body: some View {
        ScrollView {
            player.avatarImage
                .interpolation(.none)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(radius: 10)
            Text(player.nickname)
                .font(.custom(settings.fontName, size: settings.fontSize * 1.7))
            Divider()
            VStack(alignment: .leading, spacing: 0) {
                Section(header: Text("Ingame")) {
                    DetailRow("Occupation", ImageWithText(player.occupation.rawValue, player.occupation.rawValue))
                    DetailRow("Favourite mob", ImageWithText(player.favouriteMob.rawValue, player.favouriteMob.rawValue))
                }
                Section(header: Text("Favourite server")) {
                    DetailRow("Server address", Text(player.favouriteServerAddress))
                    DetailRow("Privilege", Text(player.privilege.rawValue))
                }
                Section(header: Text("Real world")) {
                    DetailRow("Name", Text(player.realworldName))
                    DetailRow("Country", Text(player.country))
                    DetailRow("City", Text(player.city))
                    DetailRow("Age", Text(String(player.age)))
                }
                if let location = player.location {
                    Section(header: Text("Location")) {
                        DetailRow("Latitude", Text("\(location.latitude)"))
                        DetailRow("Longitude", Text("\(location.longitude)"))
                    }
                }
                if player.imageIds.count != 0 {
                    Section(header: Text("Images")) {
                        if let images = player.images {
                            LazyVGrid(columns: layout) {
                                ForEach(0..<images.prefix(PlayerDetails.previewImageCount).count) { index in
                                    NavigationLink(destination: ImageGallery(images: player.images!, selectedTab: index)) {
                                        images[index]
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 50)
                                            .clipped()
                                            .cornerRadius(3)
                                    }
                                }
                                NavigationLink(destination: ImageGallery(images: player.images!)) {
                                    Text("View all")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                            .padding(.top, 10)
                        } else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }
                if let videoUrl = player.videoUrl {
                    Section(header: Text("Video")) {
                        VideoPlayer(player: AVPlayer(url: videoUrl))
                    }
                }
            }
        }
        .padding()
        .navigationBarItems(trailing: Button("Edit") {
        })
        .navigationBarTitle(player.nickname, displayMode: .inline)
        .onAppear(perform: viewModel.loadPlayerGallery)
    }
}

struct PlayerDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerDetails(viewModel: DependencyFactory.shared.getPlayerDetailsViewModel(), player: .constant(getPlayerForPreview()))
                .environmentObject(getResetSettings())
        }
    }
}
