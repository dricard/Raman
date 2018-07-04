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
    var screen = Screen()
    var device = Device()
    var locale = Language()
    var excitations = Recents(for: .wavelength)
    var signals = Recents(for: .wavelength)
    var shifts = Recents(for: .shiftInCm)
    var bandwidths = Recents(for: .bandwidthInCm)
}

extension Environment {
    static let mock = Environment(
        raman: .mock,
        selectedTheme: .mock,
        memory: .mock,
        version: .mock,
        screen: .mock,
        device: .mock,
        locale: .mock,
        excitations: .mockWavelengths,
        signals: .mockWavelengths,
        shifts: .mockShiftInCm,
        bandwidths: .mockBandwidthInNm
    )
}
