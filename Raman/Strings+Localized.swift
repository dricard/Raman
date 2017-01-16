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
    
    // MARK: - Spectro tableview
    static let excitationText = NSLocalizedString("Excitation wavelength")
    static let signalText = NSLocalizedString("Signal wavelength")
    static let shiftText = NSLocalizedString("Raman shift")

    // MARK: - Bandwidth tableview
    static let wavelength = NSLocalizedString("Wavelength")
    static let bandwidth = NSLocalizedString("Bandwidth")

    
    static let changeExcitationText = NSLocalizedString("changeExcitationText")
    static let changeSignalText = NSLocalizedString("changeSignalText")
    static let changeShiftText = NSLocalizedString("changeShiftText")
    
    static let changeExcitationBWText = NSLocalizedString("changeExcitationBWText")
    static let changeBandwidthText = NSLocalizedString("changeBandwidthText")
}
