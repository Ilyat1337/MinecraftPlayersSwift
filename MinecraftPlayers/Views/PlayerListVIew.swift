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
    
    @EnvironmentObject private var playersViewModel: PlayersViewModel
    @EnvironmentObject private var settings: SettingsStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(playersViewModel.players) { player in
                        NavigationLink(destination: PlayerDetails(player: player)) {
                            PlayerGridElement(player: player)
                        }
                        .accentColor(settings.isDarkMode ? .white : .black)
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(Text("Players"))
        }
        
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
            .environmentObject(getLoadedPlayersViewModel())
            .environmentObject(getResetSettings())
    }
}
