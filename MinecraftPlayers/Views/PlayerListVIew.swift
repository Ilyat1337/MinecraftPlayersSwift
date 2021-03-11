//
//  ContentView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct PlayerListView: View {
    let layout = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var playersStore: PlayersStore
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(0..<playersStore.players.count, id: \.self) { index in
                    NavigationLink(destination: PlayerDetails(viewModel: DependencyFactory.shared.getPlayerDetailsViewModel(), player: $playersStore.players[index])) {
                        PlayerGridElement(player: playersStore.players[index])
                            .accentColor(settings.isDarkMode ? .white : .black)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 0.3)
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerListView()
                .environmentObject(getLoadedPlayersStore())
                .environmentObject(getResetSettings())
                .navigationBarHidden(true)
        }
    }
}
