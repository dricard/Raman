//
//  Environment.swift
//  Raman
//
//  Created by Denis Ricard on 2018-06-26.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation

struct Environment {
    var raman = Raman()
    var selectedTheme = ThemeMode()
    var memory = Memory()
    var version = Version()
}

extension Environment {
    static let mock = Environment(
        raman: Raman(signal: 980.28, pump: 632.42, bwLambda: 654.32, bwInCm: 700.0),
        selectedTheme: ThemeMode.init(mode: .lightMode),
        memory: Memory(),
        version: Version(build: "3.X", release: "omega")
    )
}
