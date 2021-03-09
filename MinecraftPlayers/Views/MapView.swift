//
//  MapView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import MapKit

fileprivate struct MapPlayerIcon: View {
    var player: Player
    
    var body: some View {
        VStack(spacing: 5) {
            Text(player.nickname)
                .padding(2)
                .foregroundColor(Color(UIColor.systemBackground))
                .colorInvert()
                .background(Color.gray.opacity(0.3))
            player.avatarImage
                .interpolation(.none)
                .resizable()
                .cornerRadius(3)
                .frame(width: 25, height: 25)
        }
    }
}

struct MapView: View {
    private static let centerCoordinates = CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893)
    @EnvironmentObject private var playersStore: PlayersStore
    @State private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: centerCoordinates, span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))
    
    var body: some View {
        Map(coordinateRegion: $coordinateRegion, annotationItems: playersStore.players.filter { $0.location != nil }) { player in
            MapAnnotation(coordinate: player.location!) {
                NavigationLink(destination: PlayerDetails(viewModel: DependencyFactory.shared.getPlayerDetailsViewModel(), player: binding(for: player))) {
                    MapPlayerIcon(player: player)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func binding(for player: Player) -> Binding<Player> {
        let playerIndex = playersStore.players.firstIndex(where: { $0.id == player.id })!
        return $playersStore.players[playerIndex]
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(getLoadedPlayersStore())
        MapPlayerIcon(player: getPlayerForPreview())
    }
}
