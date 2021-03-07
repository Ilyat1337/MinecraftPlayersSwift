//
//  PlayerGridElement.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct PlayerGridElement: View {
    @EnvironmentObject private var settings: SettingsStore
    
    var player: Player
    
    var body: some View {
        VStack(spacing: 3) {
            player.avatarImage
                .interpolation(.none)
                .resizable()
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 20)
                
                //.frame(width: 80, height: 80)
                //.cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.orange, lineWidth: 4)
            Text(player.nickname)
                .fontWeight(.bold)
                .lineLimit(1)
            Text(player.occupation.rawValue)
                .lineLimit(1)
            Text("\(player.age) y.o.")
                .lineLimit(1)
        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
    }
}

struct PlayerGridElement_Previews: PreviewProvider {
    static var previews: some View {
        PlayerGridElement(player: getPlayerForPreview())
            .frame(width: 200)
            .environmentObject(getResetSettings())
    }
}
