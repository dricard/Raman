//
//  Constants.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Constants {

    // Spectroscopy index
    
    static let excitationIndex = 0
    static let signalIndex = 1
    static let shiftCmIndex = 2
    static let shiftGhzIndex = 3
    static let shiftmeVIndex = 4
    
    // Bandwidth index
    
    static let bwExcitationIndex = 0
    static let bwCmIndex = 1
    static let bwGhzIndex = 2
    static let bwNmIndex = 3
    
    
    static let ramanShift: [String] = [ .excitationText, .signalText, .shiftText, .shiftText, .shiftText]
    
    static let ramanBandwidth: [String] = [ .wavelength, .bandwidth, .bandwidth, .bandwidth]
    
    static let specUnits = ["nm", "nm", "cm-1", "GHz", "MeV"]
    static let bwUnits = ["nm", "cm-1", "GHz", "nm"]
    static let bwEpx = ["", "-1", "", ""]

    static let specRounding = [".2", ".2", ".4", ".2", ".5" ]
    static let bwRounding = [".2", ".4", ".2", ".2" ]
    
    static let specToolTip: [String] = [ .changeExcitationText, .changeSignalText, .changeShiftText, .changeShiftText, .changeShiftText ]

    static let bwToolTip: [String] = [ .changeExcitationBWText, .changeBandwidthText, .changeBandwidthText, .changeBandwidthText]
}
