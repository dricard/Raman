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
    
    // MARK: - Properties
    var mode: ThemeModes = .darkMode
    
}
