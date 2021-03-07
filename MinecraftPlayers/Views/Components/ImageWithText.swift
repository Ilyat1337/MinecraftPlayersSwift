//
//  ImageWithText.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/5/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct ImageWithText: View {
    private var imageName: String
    private var text: String
    
    init(_ imageName: String, _ text: String) {
        self.imageName = imageName
        self.text = text
    }
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .interpolation(.none)
                .frame(width: 16, height: 16)
            Text(text)
        }
    }
}

struct ImageWithText_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            Picker(selection: .constant("Creeper"), label: Text("Occupation")) {
                ImageWithText("Creeper", "Creeper")
                    .tag("Creeper")
            }
        }
    }
}
