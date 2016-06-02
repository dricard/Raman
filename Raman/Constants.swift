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
    
    
    static let ramanShift = ["Excitation wavelenth (nm)", "Signal wavelength (nm)", "Raman shift (cm-1)", "Raman shift (GHz)", "Raman shift (meV)"]
    
    static let ramanBandwidth = ["Wavelength (nm)", "Bandwidth (cm-1)", "Bandwidth (GHz)", "Bandwidth (nm)"]
    
    static let specUnits = ["nm", "nm", "cm-1", "GHz", "MeV"]
    static let bwUnits = ["nm", "cm-1", "GHz", "nm"]

    static let specRounding = [".2", ".2", ".4", ".2", ".5" ]
    static let bwRounding = [".2", ".4", ".2", ".2" ]
    
    static let changeExcitationText = "Changing the excitation value will modify the signal based on the current Raman shift."
    static let changeSignalText = "Changing the signal value will modify the Raman shift based on the current excitation."
    static let changeShiftText = "Changing the Raman shift value will modify the signal based on the current excitation."
    
    static let specToolTip = [ changeExcitationText, changeSignalText, changeShiftText, changeShiftText, changeShiftText ]
    
    static let changeExcitationBWText = "Changing the excitation wavelength used for bandwidth calculations will modify the Raman bandwidth values."
    static let changeBandwidthText = "Changing the current Raman bandwidth value will modify the other two units values (using the current selected excitation wavelength)."

    static let bwToolTip = [ changeExcitationBWText, changeBandwidthText, changeBandwidthText, changeBandwidthText]
}
