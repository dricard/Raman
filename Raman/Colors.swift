//
//  Colors.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-19.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation

enum ColorSets: Int {
    case set0 = 0
    case set1
    case set2
    case set3
    case set4
}

enum ThemeModes: String {
    case dark = "dark"
    case light = "light"
}

class Colors {
    
    var darkSet: ColorSets = .set2
    var lightSet: ColorSets = .set2
    private var _mode: ThemeModes = .light
    
    var mode: ThemeModes {
        get {
            return _mode
        }
    }
    
    func prefix() -> String {
        switch _mode {
        case .light:
            return "\(lightSet.rawValue)_\(mode.rawValue)_"
        case .dark:
            return "\(darkSet.rawValue)_\(mode.rawValue)_"
        }
    }
    
    func toggle() {
        if _mode == .light {
            _mode = .dark
        } else {
            _mode = .light
        }
    }

    func save() {
        UserDefaults.standard.set(darkSet.rawValue, forKey: "darkSet")
        UserDefaults.standard.set(lightSet.rawValue, forKey: "lightSet")
        switch _mode {
        case .light:
            UserDefaults.standard.set("light", forKey: "colorMode")
        case .dark:
            UserDefaults.standard.set("dark", forKey: "colorMode")
        }
    }
    
    func load() {
        // color sets
        if let savedMode = UserDefaults.standard.string(forKey: "colorMode") {
            if savedMode == "light" {
                _mode = .light
            } else {
                _mode = .dark
            }
        } else {
            _mode = .dark
            darkSet = .set2
            lightSet = .set2
            return
        }
        let savedDarkSet = UserDefaults.standard.integer(forKey: "darkSet")
        switch savedDarkSet {
        case 0:
            darkSet = .set0
        case 1:
            darkSet = .set1
        case 2:
            darkSet = .set2
        case 3:
            darkSet = .set3
        case 4:
            darkSet = .set4
        default:
            darkSet = .set2
        }
        
        let savedLightSet = UserDefaults.standard.integer(forKey: "lightSet")
        switch savedLightSet {
        case 0:
            lightSet = .set0
        case 1:
            lightSet = .set1
        case 2:
            lightSet = .set2
        case 3:
            lightSet = .set3
        case 4:
            lightSet = .set4
        default:
            lightSet = .set2
        }
    }
}

extension Colors {
    static let mock = Colors()
}
