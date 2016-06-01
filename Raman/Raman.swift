//
//  Raman.swift
//  
//
//  Created by Denis Ricard on 2015-05-14.
//
//

import UIKit

class Raman {

    // MARK: Constants
    
    let cInAir = 299709000
    let cInVacuum = 299792458
    

    // MARK: Properties
    
    var signal : Double
    var pump : Double
    var bwInCm : Double
    var bwLambda : Double
    
    enum DataSourceType {
        case Spectroscopy
        case Bandwidth
    }
    
    // MARK: Computed properties
    
    var shiftInCm : Double {
        get {
            if signal != 0 {
                return 1.0 / (0.0000001 * pump ) - 1.0 / ( 0.0000001 * signal )
            } else {
                print("ERROR in shiftInCm -- invalid value for variable named 'signal'")
                return 0.0
            }
        }
        set {
            if pump != 0 && ( newValue < (1.0 / (0.0000001 * pump)) - 1.0 ) {
                signal = 1.0 / ( 1.0 / pump - ( 0.0000001 * newValue ))
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
            } else {
                let alternateValue : Double
                if pump != 0 {
                    alternateValue =  (1.0 / (0.0000001 * pump)) - 1.0
                } else {
                    alternateValue = (1.0 / (0.0000001)) - 1.0
                }
                signal = 1.0 / ( 1.0 / pump - ( 0.0000001 * alternateValue ))
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
                print("ERROR in shiftInCm -- invalid value for variable named 'pump' or 'newValue'")
            }
        }
    } // variable 'shift' in cm-1

    var shiftInGhz : Double {
        get {
            if pump != 0 {
                return Double(cInAir) * ( signal - pump ) / pow(pump, 2.0)
            } else {
                print("ERROR in shiftInGhz -- invalid value for variable named 'pump'")
                return 0.0
            }
        }
        set {
            if pump != 0 && newValue > -1.0 * Double(cInAir) / pump {
                signal = newValue * pow(pump, 2.0) / Double(cInAir) + pump
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
            } else {
                let alternateValue : Double
                if pump != 0 {
                    alternateValue = -1.0 * Double(cInAir) / pump + 1
                } else {
                    alternateValue = -1.0 * Double(cInAir)
                }
                signal = alternateValue * pow(pump, 2.0) / Double(cInAir) + pump
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
                print("ERROR in shiftInGhz -- invalid value for variable named 'newValue' (should be greater than \(-1.0 * Double(cInAir) / pump)")
            }
        }
    }
    
    var shiftInMev : Double {
        get {
            if pump != 0 && signal != 0 {
                return ( 1240.6 / pump - 1240.6 / signal ) * 1000.0
            } else {
                print("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'signal'")
                return 0.0
            }
        }
        set {
            if pump != 0 && newValue != 0 && newValue < (1240600.0 / pump) {
                signal = 1240600.0 / (1240600.0 / pump - newValue)
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
            } else {
                let alternateValue = (1240600.0 / pump) - 1
                signal = 1240600.0 / (1240600.0 / pump - alternateValue)
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
                print("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'newValue'")
            }
        }
    }
    
    var bwInGhz : Double {
        get {
            if bwLambda != 0 {
                return Double(cInAir) * bwInNm / pow(bwLambda, 2.0)
            } else {
                print("ERROR in bwInGhz -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            if bwLambda != 0 {
                let temp = newValue * pow(bwLambda, 2.0) / Double(cInAir)
                bwInCm = (1/bwLambda - (1 / (temp + bwLambda)))/0.0000001
                NSUserDefaults.standardUserDefaults().setDouble(bwInCm, forKey: "bwInCm")
            } else {
                // do nothing, the value will not change and stay as it was before
                print("ERROR in bwInGhz -- invalid value for variable named 'bwLambda'")
            }
        }
    }
    
    var bwInNm : Double {
        get {
            if bwLambda != 0 {
                return (1.0 / ( 1.0 / bwLambda - ( 0.0000001 * bwInCm ))) - bwLambda
            } else {
                print("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            if bwLambda != 0 {
                bwInCm = ( 1.0 / bwLambda - (1.0 / (newValue + bwLambda))) / 0.0000001
                NSUserDefaults.standardUserDefaults().setDouble(bwInCm, forKey: "bwInCm")
            } else {
                // do nothing, the value will not change and stay as it was before
                print("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
            }
        }
    }
    
    // MARK: Methods
    
    func lamdaS(lambda: Double, bandwidth: Double) -> Double {
        if lambda != 0 {
            return 1.0 / ( 1.0 / lambda - ( 0.0000001 * bandwidth ))
        } else {
            print("ERROR in lambdaS function -- invalid value for variable named 'lambda'")
            return 0.0
        }
    }
    
    func specData(index: Int) -> Double {
        
        switch index {
        case Constants.excitationIndex: return pump
        case Constants.signalIndex: return signal
        case Constants.shiftCmIndex: return shiftInCm
        case Constants.shiftGhzIndex: return shiftInGhz
        case Constants.shiftmeVIndex: return shiftInMev
        default:
            print("ERROR in Raman.swift - wrong argument for specData: \(index)")
            return 1.0
        }
    }
 
    func bwData(index: Int) -> Double {
        
        switch index {
        case Constants.bwExcitationIndex: return bwLambda
        case Constants.bwCmIndex: return bwInCm
        case Constants.bwGhzIndex: return bwInGhz
        case Constants.bwNmIndex: return bwInNm
        default:
            print("ERROR in Raman.swift - wrong argument for bwData: \(index)")
            return 1.0
        }
    }
    
    func checkForValidData(value: Double, forDataSource: Int, inWhichTab: DataSourceType) -> (valid: Bool, errorMessage: String?) {

        if value == 0.0 {
            return (false, "Value cannot be zero")
        }
        if inWhichTab == .Spectroscopy {
            switch forDataSource {
            case Constants.excitationIndex:
                if value > 0 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a wavelength between 1nm and 10000nm")
                }
            case Constants.signalIndex:
                if value > 0 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a wavelength between 1nm and 10000nm")
                 }
            case Constants.shiftCmIndex:
                if value > -100000 && value < 100000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 100000cm-1")
                }
            case Constants.shiftGhzIndex:
                if value > -90000000 && value < 90000000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 90000000GHz")
                }
            case Constants.shiftmeVIndex:
                if value > -10000 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 10000meV")
                }
            default:
                print("ERROR in checkForValidValue of Spectroscopy - \(value) for \(forDataSource)")
                return(true, nil)
            }
        } else {
            switch forDataSource {
            case Constants.bwExcitationIndex:
                if value > 0 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a wavelength between 1nm and 10000nm")
                }
            case Constants.bwCmIndex:
                if value > -10000 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 10000cm-1")
                }
            case Constants.bwGhzIndex:
                if value > -90000000 && value < 90000000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 90000000GHz")
                }
            case Constants.bwNmIndex:
                if value > -10000 && value < 10000 {
                    return (true, nil)
                } else {
                    return (false, "Please enter a shift in the range +/- 10000meV")
                }
            default:
                print("ERROR in checkForValidValue of Bandwidth data - \(value) for \(forDataSource)")
                return(true, nil)
            }
        }

    }

    func updateParameter(value: Double, forDataSource: Int, inWhichTab: DataSourceType) {
        if inWhichTab == .Spectroscopy {
            switch forDataSource {
            case Constants.excitationIndex:
                pump = value
                NSUserDefaults.standardUserDefaults().setDouble(pump, forKey: "pump")
            case Constants.signalIndex:
                signal = value
                NSUserDefaults.standardUserDefaults().setDouble(signal, forKey: "signal")
            case Constants.shiftCmIndex:
                shiftInCm = value
            case Constants.shiftGhzIndex:
                shiftInGhz = value
            case Constants.shiftmeVIndex:
                shiftInMev = value
            default:
                print("ERROR in updateParameter - default case for Spectroscopy should not happen")
                break
            }
        } else {
            switch forDataSource {
            case Constants.bwExcitationIndex:
                bwLambda = value
                NSUserDefaults.standardUserDefaults().setDouble(bwLambda, forKey: "bwLambda")
            case Constants.bwCmIndex:
                bwInCm = value
                NSUserDefaults.standardUserDefaults().setDouble(bwInCm, forKey: "bwInCm")
            case Constants.bwGhzIndex:
                bwInGhz = value
            case Constants.bwNmIndex:
                bwInNm = value
            default:
                print("ERROR in updateParameter - default case for Bandwidth should not happen")
            }
        }

    }
    
    // MARK: Initialization
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

