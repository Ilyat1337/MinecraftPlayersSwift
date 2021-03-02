//
//  MainView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1
    @EnvironmentObject private var playersStore: PlayersStore
    
    var body: some View {
        TabView(selection: $selectedTab) {           
            PlayerListView()
                .tabItem {
                    Label("List", systemImage: "person")
                }.tag(0)

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }.tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }.tag(2)

        }
        .onAppear() {
            playersStore.loadAllPlayers()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(getLoadedPlayersStore())
            .environmentObject(getResetSettings())
    }
}
