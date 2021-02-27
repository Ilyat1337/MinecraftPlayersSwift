//
//  PlayerGridElement.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct PlayerGridElement: View {
    var player: Player;
    
    var body: some View {
        VStack(spacing: 3) {
            player.image
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
                .font(.headline)
                .lineLimit(1)
            Text(player.occupation.rawValue)
                .font(.subheadline)
                .lineLimit(1)
            Text("\(player.age) y.o.")
                .font(.subheadline)
                .lineLimit(1)
        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
        //.font(.system(size: 50))
        
    }
}

struct PlayerGridElement_Previews: PreviewProvider {
    static var previews: some View {
//        List(0..<3) { item in
//            PlayerGridElement(player: testData[0])
//        }
        PlayerGridElement(player: testData[0])
            .frame(width: 200)
//        Group {
//            PlayerGridElement(player: testData[0])
//                .previewLayout(.fixed(width: 400, height: 90))
//        }
    }
}
