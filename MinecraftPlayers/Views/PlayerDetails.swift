//
//  PlayerDetails.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/19/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

fileprivate struct DetailRow: View {
    var leftText: String
    var rightText: String
    
    init(_ leftText: String, _ rightText: String) {
        self.leftText = leftText
        self.rightText = rightText
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(leftText)
                .font(.subheadline)
                .bold()
            Spacer()
            Text(rightText)
                .font(.subheadline)
        }
        .padding()
    }
}

struct PlayerDetails: View {
    @State private var text: String = ""
    
    var player: Player
    
    var body: some View {
        ScrollView {
            player.image
                .interpolation(.none)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                //.clipShape(Circle())
                //.overlay(Circle()
                    //.stroke(Color.orange, lineWidth: 4))
                .shadow(radius: 10)
            Text(player.nickname)
                .font(.title)
            Divider()
            VStack(alignment: .leading) {
                Section(header: Text("Ingame")) {
                    DetailRow("Occupation", player.occupation.rawValue)
                    DetailRow("Favourite mob", player.favouriteMob.rawValue)
                }
                Section(header: Text("Favourite server")) {
                    DetailRow("Server address", player.favouriteServerAddress)
                    DetailRow("Privilege", player.privilege.rawValue)
                }
                Section(header: Text("Real world")) {
                    DetailRow("Name", player.realworldName)
                    DetailRow("Country", player.country)
                    DetailRow("City", player.city)
                }
                Section(header: Text("Real world")) {
                    DetailRow("Name", player.realworldName)
                    DetailRow("Country", player.country)
                    DetailRow("City", player.city)
                }
            }
            
            
            //Spacer()
//            Text(player.name)
//                .font(.title)
//            Text(player.headline)
//                .font(.subheadline)
//            Divider()
//            Text(player.bio)
//                .font(.headline)
//                .multilineTextAlignment(.center)
//                .lineLimit(50)
//            Section(header: Text("Section header")) {
//            }
        }
        .padding()
    }
}

struct PlayerDetails_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetails(player: testData[0])
    }
}
