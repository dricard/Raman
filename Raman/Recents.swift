//
//  Recents.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-04.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation
import os.log

fileprivate func <<(lhs:Int, rhs:Int) -> Int {
    if lhs != 9 {
        return lhs + 1
    } else {
        return 9
    }
}

fileprivate func >>(lhs:Int, rhs:Int) -> Int {
    if lhs != 0 {
        return lhs - 1
    } else {
        return 0
    }
}

enum RecentType: Int {
    case wavelength
    case shiftInCm
    case shiftInGhz
    case shiftInMev
    case bandwidthInCm
    case bandwidthInGhz
    case bandwidthInNm
}

struct Spot {
    var value: Double? = nil
    var type: RecentType
}

class Recents {
    let max = 9
    var stack = [ Spot ]()
    private var currentIndex = 0
    var isEmpty = false
    
    init(for type: RecentType) {
        for _ in 0...max {
            self.stack.append(Spot( value: nil, type: type))
        }
    }
    
    func left() -> Bool {
        if currentIndex == currentIndex << 1 {
            os_log("End of recent data going left", log: Log.general, type: .debug)
            return false
        } else {
            let lefty = currentIndex << 1
            os_log("Returning status of left data for position %d with lefty = %d", log: Log.general, type: .debug, currentIndex, lefty)
            return stack[currentIndex << 1].value != nil
        }
    }
    
    func righ() -> Bool {
        if currentIndex == currentIndex >> 1 {
            return false
        } else {
            return stack[currentIndex >> 1].value != nil
        }
    }
    
    func moveLeft() -> Bool {
        // check if we're at the end of the recents list
        if currentIndex == currentIndex << 1 {
            return false
        } else {
            // check if there *is* a value to the left of the current Spot
            if stack[ currentIndex << 1].value != nil {
                // yes there is, so switch left to that one
                currentIndex = currentIndex << 1
                return true
            } else {
                return false
            }
        }
    }

    func moveRight() -> Bool {
        if currentIndex == currentIndex >> 1 {
            return false
        } else {
            if stack[ currentIndex >> 1].value != nil {
                currentIndex = currentIndex >> 1
                return true
            } else {
                return false
            }
        }
    }

    func push(_ newValue: Double, with type: RecentType) {
        for i in (1...max).reversed() {
            stack[i] = stack[i - 1]
        }
        stack[0].value = newValue
        stack[0].type = type
        currentIndex = 0
//        print(stack)
    }
    
    func current() -> Spot {
        return stack[ currentIndex ]
    }
    
    func valueFor(_ row: Int) -> Double? {
        if let value = stack[ row ].value {
            return value
        } else {
            return nil
        }
    }
    
    func typeFor(_ row: Int) -> RecentType {
        return stack[ row ].type
    }
    
    func count() -> Int {
        return stack.map { $0.value }.compactMap{ $0 }.count
    }
    
    // saving/loading from disk
    func save(with key: String) {
        
        let noValue: Double = -1.0
        for (index, spot) in stack.enumerated() {
            let valueKey = "\(key)_value_\(index)"
            let typeKey = "\(key)_type_\(index)"
            if let value = spot.value {
                UserDefaults.standard.set(value, forKey: valueKey)
            } else {
                UserDefaults.standard.set(noValue, forKey: valueKey)
            }
            UserDefaults.standard.set(spot.type.rawValue, forKey: typeKey)
        }
        let currentKey = "\(key)_current"
        UserDefaults.standard.set(currentIndex, forKey: currentKey)
    }
    
    func load(with key: String) {
        var noDataOnDisk = false
        stack.removeAll()
        let noValue: Double = -1.0
        for index in 0...max {
            let valueKey = "\(key)_value_\(index)"
            let typeKey = "\(key)_type_\(index)"
            let value = UserDefaults.standard.double(forKey: valueKey)
            let typeIndex = UserDefaults.standard.integer(forKey: typeKey)
            let type: RecentType
            switch typeIndex {
            case 0:
                type = .wavelength
            case 1:
                type = .shiftInCm
            case 2:
                type = .shiftInGhz
            case 3:
                type = .shiftInMev
            case 4:
                type = .bandwidthInCm
            case 5:
                type = .bandwidthInGhz
            case 6:
                type = .bandwidthInNm
            default:
                os_log("Wrong typeIndex in load(): %d", log: Log.general, type: .error, typeIndex)
                type = .wavelength
            }
            if value == noValue || value == 0.0 {
                if index == 0 {
                    noDataOnDisk = true
                }
                let spot = Spot(value: nil, type: type)
                stack.append(spot)
            } else {
                let spot = Spot(value: value, type: type)
                stack.append(spot)
            }
            let currentKey = "\(key)_current"
            currentIndex = UserDefaults.standard.integer(forKey: currentKey)
            if noDataOnDisk {
                isEmpty = true
            }
        }
    }
}

extension Recents {
    static let mockWavelengths = Recents(for: .wavelength)
    static let mockShiftInCm = Recents(for: .shiftInCm)
    static let mockShiftInGhz = Recents(for: .shiftInGhz)
    static let mockShiftInMev = Recents(for: .shiftInMev)
    static let mockBandwidthInCm = Recents(for: .bandwidthInCm)
    static let mockBandwidthInGhz = Recents(for: .bandwidthInGhz)
    static let mockBandwidthInNm = Recents(for: .bandwidthInNm)

}
