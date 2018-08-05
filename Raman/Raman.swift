//
//  Raman.swift
//  
//
//  Created by Denis Ricard on 2015-05-14.
//
//

import UIKit

class Raman {

    // Notifications
    
//    static let changedNotification = Notification.Name("RamanChanged")
    
    public static var spectroChangedNotification = Notification.Name.init("com.hexaedre.raman.spectroChangedNotification")
    public static var bandwidthChangedNotification = Notification.Name.init("com.hexaedre.raman.bandwidthChangedNotification")

    // MARK: Constants
    
    let cInAir = 299709000
    let cInVacuum = 299792458
    

    // MARK: Properties
    
    private var _signal: Double
    private var _pump: Double
    private var _bwInCm: Double
    private var _bwLambda: Double
    
    var signal : Double {
        get {
            return _signal
        }
        set {
            _signal = newValue
            let userInfo: [AnyHashable:Any]? = [
                "changedValue": "signal",
                "rowsToUpdate": [
                    Constants.signalIndex,
                    Constants.shiftCmIndex,
                    Constants.shiftGhzIndex,
                    Constants.shiftmeVIndex
                ]
            ]
            NotificationCenter.default.post(name: Raman.spectroChangedNotification, object: self, userInfo: userInfo)
            UserDefaults.standard.set(_signal, forKey: Constants.keyForSignal)

        }
    }
    var pump : Double {
        get {
            return _pump
        }
        set {
            _pump = newValue
            let userInfo: [AnyHashable:Any]? = [
                "changedValue": "excitation",
                "rowsToUpdate": [
                    Constants.excitationIndex,
                    Constants.shiftCmIndex,
                    Constants.shiftGhzIndex,
                    Constants.shiftmeVIndex
                ]
            ]
            NotificationCenter.default.post(name: Raman.spectroChangedNotification, object: self, userInfo: userInfo)
            UserDefaults.standard.set(_pump, forKey: Constants.keyForPump)
        }
    }
    var bwInCm : Double {
        get {
            return _bwInCm
        }
        set {
            _bwInCm = newValue
            let userInfo: [AnyHashable:Any]? = [
                "changedValue": "bwInCm",
                "rowsToUpdate": [
                    Constants.bwCmIndex,
                    Constants.bwGhzIndex,
                    Constants.bwNmIndex
                ]
            ]
            NotificationCenter.default.post(name: Raman.bandwidthChangedNotification, object: self, userInfo: userInfo)
            UserDefaults.standard.set(bwInCm, forKey: Constants.keyForBwInCm)
        }
    }
    var bwLambda : Double {
        get {
            return _bwLambda
        }
        set {
            _bwLambda = newValue
            let userInfo: [AnyHashable:Any]? = [
                "changedValue": "bwLambda",
                "rowsToUpdate": [
                    Constants.bwExcitationIndex,
                    Constants.bwGhzIndex,
                    Constants.bwNmIndex
                ]
            ]
            NotificationCenter.default.post(name: Raman.bandwidthChangedNotification, object: self, userInfo: userInfo)
            UserDefaults.standard.set(bwLambda, forKey: Constants.keyForBwLambda)
        }
    }
    
    enum DataSourceType: String {
        case spectroscopy
        case bandwidth
    }
    
    // MARK: - Computed properties
    
    var shiftInCm : Double {
        get {
            if _signal != 0 {
                return 1.0 / (0.0000001 * _pump ) - 1.0 / ( 0.0000001 * _signal )
            } else {
                print("ERROR in shiftInCm -- invalid value for variable named 'signal'")
                return 0.0
            }
        }
        set {
            if _pump != 0 && ( newValue < (1.0 / (0.0000001 * _pump)) - 1.0 ) {
                // we use signal instead of _signal to trigger an update and a save
                signal = 1.0 / ( 1.0 / _pump - ( 0.0000001 * newValue ))
            } else {
                let alternateValue : Double
                if _pump != 0 {
                    alternateValue =  (1.0 / (0.0000001 * _pump)) - 1.0
                } else {
                    alternateValue = (1.0 / (0.0000001)) - 1.0
                }
                // we use signal instead of _signal to trigger an update and a save
                signal = 1.0 / ( 1.0 / _pump - ( 0.0000001 * alternateValue ))
                print("ERROR in shiftInCm -- invalid value for variable named 'pump' or 'newValue'")
            }
        }
    }
    
    var shiftInGhz : Double {
        get {
            if _pump != 0 {
                return Double(cInAir) * ( _signal - _pump ) / pow(_pump, 2.0)
            } else {
                print("ERROR in shiftInGhz -- invalid value for variable named 'pump'")
                return 0.0
            }
        }
        set {
            if _pump != 0 && newValue > -1.0 * Double(cInAir) / _pump {
                // we use signal instead of _signal to trigger an update and a save
                signal = newValue * pow(_pump, 2.0) / Double(cInAir) + _pump
            } else {
                let alternateValue : Double
                if _pump != 0 {
                    alternateValue = -1.0 * Double(cInAir) / _pump + 1
                } else {
                    alternateValue = -1.0 * Double(cInAir)
                }
                // we use signal instead of _signal to trigger an update and a save
                signal = alternateValue * pow(_pump, 2.0) / Double(cInAir) + _pump
                print("ERROR in shiftInGhz -- invalid value for variable named 'newValue' (should be greater than \(-1.0 * Double(cInAir) / pump)")
            }
        }
    }
    
    var shiftInMev : Double {
        get {
            if _pump != 0 && _signal != 0 {
                return ( 1240.6 / _pump - 1240.6 / _signal ) * 1000.0
            } else {
                print("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'signal'")
                return 0.0
            }
        }
        set {
            if _pump != 0 && newValue != 0 && newValue < (1240600.0 / _pump) {
                // we use signal instead of _signal to trigger an update and a save
                signal = 1240600.0 / (1240600.0 / _pump - newValue)
            } else {
                let alternateValue = (1240600.0 / _pump) - 1
                // we use signal instead of _signal to trigger an update and a save
                signal = 1240600.0 / (1240600.0 / _pump - alternateValue)
                print("ERROR in shiftInMev -- invalud value for variable named 'pump' or 'newValue'")
            }
        }
    }
    
    var bwInGhz : Double {
        get {
            if _bwLambda != 0 {
                return Double(cInAir) * bwInNm / pow(_bwLambda, 2.0)
            } else {
                print("ERROR in bwInGhz -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            if _bwLambda != 0 {
                let temp = newValue * pow(_bwLambda, 2.0) / Double(cInAir)
                // we use bwInCm instead of _bwInCm to trigger an update and a save
                bwInCm = (1/_bwLambda - (1 / (temp + _bwLambda)))/0.0000001
            } else {
                // do nothing, the value will not change and stay as it was before
                print("ERROR in bwInGhz -- invalid value for variable named 'bwLambda'")
            }
        }
    }
    
    var bwInNm : Double {
        get {
            if _bwLambda != 0 {
                return (1.0 / ( 1.0 / _bwLambda - ( 0.0000001 * _bwInCm ))) - _bwLambda
            } else {
                print("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
                return 0.0
            }
        }
        set {
            if _bwLambda != 0 {
                // we use bwInCm instead of _bwInCm to trigger an update and a save
                bwInCm = ( 1.0 / _bwLambda - (1.0 / (newValue + _bwLambda))) / 0.0000001
            } else {
                // do nothing, the value will not change and stay as it was before
                print("ERROR in bwInNm -- invalid value for variable named 'bwLambda'")
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        _signal = 534.0
        _pump = 532.0
        _bwLambda = 532.0
        _bwInCm = 70.4007209033807
        
    }
    
    init(signal : Double, pump : Double, bwLambda : Double, bwInCm : Double) {
        self._signal = signal
        self._pump = pump
        self._bwLambda = bwLambda
        self._bwInCm = bwInCm
    }
    
    // MARK: - Methods
    
    func lamdaS(_ lambda: Double, bandwidth: Double) -> Double {
        if lambda != 0 {
            return 1.0 / ( 1.0 / lambda - ( 0.0000001 * bandwidth ))
        } else {
            print("ERROR in lambdaS function -- invalid value for variable named 'lambda'")
            return 0.0
        }
    }
    
    func specData(_ index: Int) -> Double {
        
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
 
    func bwData(_ index: Int) -> Double {
        
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
    
    func checkForValidData(_ value: Double, forDataSource: Int, inWhichTab: DataSourceType) -> (valid: Bool, errorMessage: String?) {

        if value == 0.0 {
            return (false, "Value cannot be zero")
        }
        if inWhichTab == .spectroscopy {
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

    func updateParameter(_ value: Double, forDataSource: Int, inWhichTab: DataSourceType) {
        if inWhichTab == .spectroscopy {
            switch forDataSource {
            case Constants.excitationIndex:
                pump = value
            case Constants.signalIndex:
                signal = value
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
            case Constants.bwCmIndex:
                bwInCm = value
            case Constants.bwGhzIndex:
                bwInGhz = value
            case Constants.bwNmIndex:
                bwInNm = value
            default:
                print("ERROR in updateParameter - default case for Bandwidth should not happen")
            }
        }

    }
    
    
    
}


extension Raman {
    static let mock = Raman(signal: 980.28, pump: 632.42, bwLambda: 654.32, bwInCm: 700.0)
}

extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}
