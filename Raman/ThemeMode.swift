//
//  ThemeMode.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-15.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

enum ThemeModes: Int {
    case darkMode = 1
    case lightMode
}

class ThemeMode {
    
    init(mode: ThemeModes = .darkMode) {
        self.mode = mode
    }
    
    // MARK: - Properties
    var mode: ThemeModes = .darkMode
    
    func prefix() -> String {
        switch mode {
        case .darkMode:
            return "dark_"
        case .lightMode:
            return "light_"
        }
    }
}

extension ThemeMode {
    static let mock = ThemeMode.init(mode: .lightMode)
}
