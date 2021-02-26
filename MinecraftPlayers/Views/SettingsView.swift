//
//  SettingsView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var loggedUserStore: LoggedUserStore
    
    var body: some View {
        NavigationView {
            Form {
                Picker(
                    selection: $settings.locale,
                    label: Text("Language")
                ) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                }
                
                ColorPicker("Color", selection: $settings.color)
                
                Toggle(isOn: $settings.isDarkMode) {
                    Text("Dark mode")
                }
                
                HStack {
                    Text("Font size")
                    Spacer(minLength: 40)
                    Slider(value: $settings.fontSize, in: 6...40)
                }
                
                Button(action: {
                    self.settings.resetDefaults()
                }) {
                    Text("Reset settings")
                }
                
                Section {
                    Button(action: {
                        loggedUserStore.userId = ""
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
            .navigationBarTitle(Text("Settings"))
        }
        //.environment(\.colorScheme, settings.colorScheme)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(getResetSettings())
            .environmentObject(getResetLoggedUserStore())
    }
}
