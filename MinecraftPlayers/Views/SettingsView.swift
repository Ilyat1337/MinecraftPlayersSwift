//
//  SettingsView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    private let fontNames = ["Helvetica", "Avenir Next", "Noteworthy", "Papyrus", "Chalkboard SE"]
    
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var loggedUserStore: LoggedUserStore
    @EnvironmentObject private var playersStore: PlayersStore
    
    var body: some View {
        Form {
            Picker(
                selection: $settings.locale,
                label: Text("Language")
            ) {
                Text("English").tag("en")
                Text("Русский").tag("ru")
            }
            
            Picker(
                selection: $settings.fontName,
                label: Text("Font name")
            ) {
                ForEach(0..<fontNames.count) { index in
                    Text(fontNames[index])
                        .font(.custom(fontNames[index], size: CGFloat(settings.fontSize)))
                        .tag(fontNames[index])
                }
            }
            
            HStack {
                Text("Font size (\(Int(settings.fontSize)) pt)")
                Spacer(minLength: 40)
                Slider(value: $settings.fontSize, in: 10...25)
            }
            
            ColorPicker("Color", selection: $settings.color)
            
            Toggle(isOn: $settings.isDarkMode) {
                Text("Dark mode")
            }
            
            Button(action: {
                self.settings.resetDefaults()
            }) {
                Text("Reset settings")
            }
            
            Section {
                Button(action: {
                    playersStore.resetArePlayersLoaded()
                    loggedUserStore.logOut()
                }) {
                    HStack {
                        Spacer()
                        Text("Log out")
                        Spacer()
                    }
                }
                .accentColor(.red)
            }
        }
        //.environment(\.colorScheme, settings.colorScheme)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(getResetSettings())
                .environmentObject(getResetLoggedUserStore())
                .environmentObject(getLoadedPlayersStore())
                .navigationBarHidden(true)
        }
    }
}
