//
//  ImageData.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/1/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Foundation

struct ImageData {
    var id: String
    var data: Data
    
    init(_ id: String, _ data: Data) {
        self.id = id
        self.data = data
    }
    
}
