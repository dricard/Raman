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
    var version = Version()
    var screen = Screen()
    var device = Device()
    var locale = Language()
    var excitations = Recents(for: .wavelength, with: Constants.recentsExcitationKey)
    var signals = Recents(for: .wavelength, with: Constants.recentsSignalsKey)
    var wavelengths = Recents(for: .wavelength, with: Constants.recentsWavelengthKey)
    var shifts = Recents(for: .shiftInCm, with: Constants.recentsShiftsKey)
    var bandwidths = Recents(for: .bandwidthInCm, with: Constants.recentsBandwidthsKey)
    var colorSet = Colors()
}

extension Environment {
    static let mock = Environment(
        raman: .mock,
        version: .mock,
        screen: .mock,
        device: .mock,
        locale: .mock,
        excitations: .mockWavelengths,
        signals: .mockWavelengths,
        wavelengths: .mockWavelengths,
        shifts: .mockShiftInCm,
        bandwidths: .mockBandwidthInNm,
        colorSet: .mock
    )
}
