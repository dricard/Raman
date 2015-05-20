//
//  Raman.swift
//  
//
//  Created by Denis Ricard on 2015-05-14.
//
//

import UIKit

//var spectros : Raman()

class Raman {

    // constants
    let cInAir = 299709000
    let cInVacuum = 299792458
    
    // properties
    var signal : Double
    var pump : Double
    var bwInCm : Double
    var bwLambda : Double
    
    // computed properties
    var shiftInCm : Double {
        get {
            if signal != 0 {
                return 1.0 / (0.0000001 * pump ) - 1.0 / ( 0.0000001 * signal )
            } else {
                println("ERROR in shiftInCm -- invalid value for variable named 'signal'")
                return 0.0
            }
        }
        set {
            if pump != 0 && ( newValue < (1.0 / (0.0000001 * pump)) - 1.0 ) {
                signal = 1.0 / ( 1.0 / pump - ( 0.0000001 * newValue ))
            } else {
                let alternateValue : Double
                if pump != 0 {
                    alternateValue =  (1.0 / (0.0000001 * pump)) - 1.0
                } else {
                    alternateValue = (1.0 / (0.0000001)) - 1.0
                }
                signal = 1.0 / ( 1.0 / pump - ( 0.0000001 * alternateValue ))
                println("ERROR in shiftInCm -- invalid value for variable named 'pump' or 'newValue'")
            }
        }
    } // variable 'shift' in cm-1

    var shiftInGhz : Double {
        get {
            if pump != 0 {
                return Double(cInAir) * ( signal - pump ) / pow(pump, 2.0)
            } else {
                println("ERROR in shiftInGhz -- invalid value for variable named 'pump'")
                return 0.0
            }
        }
        set {
            if pump != 0 && newValue > -1.0 * Double(cInAir) / pump {
                signal = newValue * pow(pump, 2.0) / Double(cInAir) + pump
            } else {
                let alternateValue : Double
                if pump != 0 {
                    alternateValue = -1.0 * Double(cInAir) / pump + 1
                } else {
                    alternateValue = -1.0 * Double(cInAir)
                }
                signal = alternateValue * pow(pump, 2.0) / Double(cInAir) + pump
                println("ERROR in shiftInGhz -- invalid value for variable named 'newValue' (should be greater than \(-1.0 * Double(cInAir) / pump)")
            }
        }
    }
    
    var shiftInMev : Double {
        get {
            if pump != 0 && signal != 0 {
                return ( 1240.6 / pump - 1240.6 / signal ) * 1000.0
            } else {
                println("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'signal'")
                return 0.0
            }
        }
        set {
            if pump != 0 && newValue != 0 && newValue < (1240600.0 / pump) {
                signal = 1240600.0 / (1240600.0 / pump - newValue)
            } else {
                let alternateValue = (1240600.0 / pump) - 1
                signal = 1240600.0 / (1240600.0 / pump - alternateValue)
                println("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'newValue'")
            }
        }
    }
    
    var bwInGhz : Double {
        get {
            if bwLambda != 0 {
                return Double(cInAir) * bwInNm / pow(bwLambda, 2.0)
            } else {
                println("ERROR in bwInGhz -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            bwInCm = newValue * pow(bwLambda, 2.0) / Double(cInAir)
        }
    }
    
    var bwInNm : Double {
        get {
            if bwLambda != 0 {
                return (1.0 / ( 1.0 / bwLambda - ( 0.0000001 * bwInCm ))) - bwLambda
            } else {
                println("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            if bwLambda != 0 {
                bwInCm = ( 1.0 / bwLambda - (1.0 / (newValue + bwLambda))) / 0.0000001
            } else {
                // do nothing, the value will not change and stay as it was before
                println("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
            }
        }
    }
    
    // Methods
    
    func lamdaS(lambda: Double, bandwidth: Double) -> Double {
        if lambda != 0 {
            return 1.0 / ( 1.0 / lambda - ( 0.0000001 * bandwidth ))
        } else {
            println("ERROR in lambdaS function -- invalid value for variable named 'lambda'")
            return 0.0
        }
    }
    
    // Initialization
    init() {
        signal = 534.0
        pump = 532.0
        bwLambda = 532.0
        bwInCm = 70.4007209033807
        
    }
    
    init(signal : Double, pump : Double, bwLambda : Double, bwInCm : Double) {
        self.signal = signal
        self.pump = pump
        self.bwLambda = bwLambda
        self.bwInCm = bwInCm
    }
}

