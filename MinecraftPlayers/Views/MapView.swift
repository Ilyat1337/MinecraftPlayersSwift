//
//  MapView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct MapView: View {
    //@EnvironmentObject var playersViewModel: PlayersViewModel
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
//            Text("Map!")
//            Button("Test") {
//                //playersViewModel.players.remove(at: 0)
//                playersViewModel.players[0].nickname = "New name!"
//            }
            Image("Steve")
                .interpolation(.none)
                .resizable()
                .scaleEffect(scale)
                .frame(width: 100, height: 100)
                .gesture(MagnificationGesture()
                            .onChanged {value in
                                self.scale = value.magnitude
                            })
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
