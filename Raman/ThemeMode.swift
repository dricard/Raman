//
//  ThemeMode.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-15.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation


class ThemeMode {
    
    init(mode: ThemeModes = .dark) {
        self.mode = mode
    }
    
    // MARK: - Properties
    var mode: ThemeModes = .dark
    
    func prefix() -> String {
        switch mode {
        case .dark:
            return "dark_"
        case .light:
            return "light_"
        }
    }
}

extension ThemeMode {
    static let mock = ThemeMode.init(mode: .light)
}
