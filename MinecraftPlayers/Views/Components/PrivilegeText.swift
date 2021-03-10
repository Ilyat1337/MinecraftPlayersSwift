//
//  PrivilegeText.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/10/21.
//

import SwiftUI

struct PrivilegeText: View {
    var privilege: Player.PrivilegeType
    
    var body: some View {
        Text(LocalizedStringKey(privilege.rawValue))
            .foregroundColor(privilege.getColor())            
    }
}

struct PrivilegeText_Previews: PreviewProvider {
    static var previews: some View {
        PrivilegeText(privilege: .mvpPlus)
    }
}
