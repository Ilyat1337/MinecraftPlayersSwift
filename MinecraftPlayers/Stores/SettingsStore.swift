//
//  SettingsStore.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/21/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

final class SettingsStore: ObservableObject {
    private enum Keys {
        static let locale = "locale"
        static let color = "color"
        static let isDarkMode = "color_scheme"
        static let fontName = "font_name"
        static let fontSize = "font_size"
    }
    
    private static let defaultLocale = "en"
    private static let defaultColor = Color.orange
    private static let defaultIsDarkMode = false
    private static let defaultFontName = "Helvetica"
    private static let defaultFontSize: CGFloat = 17.0

    private let defaults: UserDefaults
    
    @Published var locale: String {
        didSet {
            defaults.set(locale, forKey: Keys.locale)
        }
    }

    @Published var color: Color {
        didSet {
            defaults.set(color, forKey: Keys.color)
        }
    }
    
    var colorScheme: ColorScheme {
        get { isDarkMode ? .dark : .light }
    }
    
    @Published var isDarkMode: Bool {
        didSet {
            defaults.set(isDarkMode, forKey: Keys.isDarkMode)
        }
    }
    
    @Published var fontName: String {
        didSet {
            defaults.set(fontName, forKey: Keys.fontName)
        }
    }
    
    @Published var fontSize: CGFloat {
        didSet {
            defaults.set(fontSize, forKey: Keys.fontSize)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.locale: SettingsStore.defaultLocale,
            Keys.isDarkMode: SettingsStore.defaultIsDarkMode,
            Keys.fontSize: SettingsStore.defaultFontSize,
            Keys.fontName: SettingsStore.defaultFontName
            ])
        
        locale = defaults.string(forKey: Keys.locale) ?? SettingsStore.defaultLocale
        color = defaults.color(forKey: Keys.color) ?? SettingsStore.defaultColor
        isDarkMode = defaults.bool(forKey: Keys.isDarkMode)
        fontSize = CGFloat(defaults.float(forKey: Keys.fontSize))
        fontName = defaults.string(forKey: Keys.fontName) ?? SettingsStore.defaultFontName
    }
    
    func resetDefaults() {
        locale = SettingsStore.defaultLocale
        color = SettingsStore.defaultColor
        isDarkMode = SettingsStore.defaultIsDarkMode
        fontSize = SettingsStore.defaultFontSize
        fontName = SettingsStore.defaultFontName
    }   
}

extension Numeric {
    var data: Data {
        var bytes = self
        return Data(bytes: &bytes, count: MemoryLayout<Self>.size)
    }
}

extension Data {
    func object<T>() -> T { withUnsafeBytes{$0.load(as: T.self)} }
    var color: UIColor { .init(data: self) }
}

extension UIColor {
    convenience init(data: Data) {
        let size = MemoryLayout<CGFloat>.size
        self.init(red:   data.subdata(in: size*0..<size*1).object(),
                  green: data.subdata(in: size*1..<size*2).object(),
                  blue:  data.subdata(in: size*2..<size*3).object(),
                  alpha: data.subdata(in: size*3..<size*4).object())
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        return getRed(&red, green: &green, blue: &blue, alpha: &alpha) ?
        (red, green, blue, alpha) : nil
    }
    
    var data: Data? {
        guard let rgba = rgba else { return nil }
        return rgba.red.data + rgba.green.data + rgba.blue.data + rgba.alpha.data
    }
}

extension UserDefaults {
    func set(_ color: Color, forKey defaultName: String) {
        let uiColor = UIColor(color)
        set(uiColor.data, forKey: defaultName)
    }
    
    func color(forKey defaultName: String) -> Color? {
        guard let uiColor = data(forKey: defaultName)?.color else {
            return nil
        }
        return Color(uiColor)
    }
}

//For preview

func getResetSettings() -> SettingsStore {
    let settingsStore = SettingsStore()
    settingsStore.resetDefaults()
    return settingsStore
}
