//
//  Strings+Localized.swift
//  Raman
//
//  Created by Denis Ricard on 2017-01-15.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

fileprivate func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension String {
    
    static let about = NSLocalizedString("About")
    
    // MARK: - Info view
    
    static let aboutRaman = NSLocalizedString("About Raman")
    static let madeBy = NSLocalizedString("is made by")
    static let ideaBy = NSLocalizedString("Based on an original idea by")
    static let thanksTo = NSLocalizedString("Special thanks to")
    static let helpButton = NSLocalizedString("Help")
    static let supportButton = NSLocalizedString("Support")
    static let doneButton = NSLocalizedString("Done")
    
    // MARK: - Spectro tableview
    static let excitationText = NSLocalizedString("Excitation wavelength")
    static let signalText = NSLocalizedString("Signal wavelength")
    static let shiftText = NSLocalizedString("Raman shift")

    // MARK: - Bandwidth tableview
    static let bandwidthTitle = NSLocalizedString("Bandwidth")
    static let wavelength = NSLocalizedString("Wavelength")
    static let bandwidth = NSLocalizedString("Bandwidth")

    // MARK: - Edit value
    
    static let editValueLabel = NSLocalizedString("Edit value")
    static let instructionLabel = NSLocalizedString("Enter a new value for")
    static let currentValueLabel = NSLocalizedString("Current value")
    static let cancelButton = NSLocalizedString("Cancel")
    
    static let changeExcitationText = NSLocalizedString("changeExcitationText")
    static let changeSignalText = NSLocalizedString("changeSignalText")
    static let changeShiftText = NSLocalizedString("changeShiftText")
    
    static let changeExcitationBWText = NSLocalizedString("changeExcitationBWText")
    static let changeBandwidthText = NSLocalizedString("changeBandwidthText")
}
