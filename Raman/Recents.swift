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

enum RecentType {
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
