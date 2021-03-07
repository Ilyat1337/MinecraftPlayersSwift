//
//  MainView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @EnvironmentObject private var playersStore: PlayersStore
    @EnvironmentObject private var settings: SettingsStore
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {           
                PlayerListView()
                    .tabItem {
                        Label("Players", systemImage: "person")
                    }
                    .tag(0)
                    .navigationBarHidden(true)
                
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(1)
                    .navigationBarHidden(true)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
                    .navigationBarHidden(true)
                
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear() {
                playersStore.loadAllPlayers()
            }
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
