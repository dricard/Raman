//
//  Constants.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Constants {

    static let ramanShift = ["Excitation wavelenth (nm)", "Signal wavelength (nm)", "Raman shift (cm-1)", "Raman shift (GHz)", "Raman shift (meV)"]
    
    static let ramanBandwidth = ["Wavelength for bw calculations (nm)", "Bandwidth (cm-1)", "Bandwidth (GHz)", "Bandwidth (nm)"]
    
    static let cellImage = [UIImage(named: "excitationInNmIcon"), UIImage(named: "signalInNmIcon"), UIImage(named: "shiftInCmIcon"), UIImage(named: "shiftInGhzIcon"), UIImage(named: "shiftInMevIcon")]

    static let bwCellImage = [UIImage(named: "excitationInNmIcon"), UIImage(named: "bwInCmIcon"), UIImage(named: "bwInGhzIcon"), UIImage(named: "bwInNmIcon")]

}
