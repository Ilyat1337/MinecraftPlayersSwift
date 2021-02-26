//
//  MapView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var playersViewModel: PlayersViewModel
    
    var body: some View {
        VStack {
            Text("Map!")
            Button("Test") {
                //playersViewModel.players.remove(at: 0)
                playersViewModel.players[0].nickname = "New name!"
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
