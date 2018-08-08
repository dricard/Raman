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
    case wavelength = 0
    case shiftInCm
    case shiftInGhz
    case shiftInMev
    case bandwidthInCm
    case bandwidthInGhz
    case bandwidthInNm
}

struct Spot {
    var value: Double
    var type: RecentType
}

class Recents {
    
    // MARK: - Properties
    
    let max = 9
    var stack = [ Spot? ]()
    private var currentIndex = 0
    var key: String
    
    var isEmpty: Bool {
        return count() == 0
    }
    
    init(for type: RecentType, with key: String) {
        self.key = key
        for _ in 0...max {
            self.stack.append(nil)
        }
    }
    
    func left() -> Bool {
        if currentIndex == currentIndex << 1 {
            os_log("End of recent data going left", log: Log.general, type: .debug)
            return false
        } else {
            let lefty = currentIndex << 1
            os_log("Returning status of left data for position %d with lefty = %d", log: Log.general, type: .debug, currentIndex, lefty)
            return stack[currentIndex << 1] != nil
        }
    }
    
    func righ() -> Bool {
        if currentIndex == currentIndex >> 1 {
            return false
        } else {
            return stack[currentIndex >> 1] != nil
        }
    }
    
    func moveLeft() -> Bool {
        // check if we're at the end of the recents list
        if currentIndex == currentIndex << 1 {
            return false
        } else {
            // check if there *is* a value to the left of the current Spot
            if stack[ currentIndex << 1] != nil {
                // yes there is, so switch left to that one
                currentIndex = currentIndex << 1
                save()
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
            if stack[ currentIndex >> 1] != nil {
                currentIndex = currentIndex >> 1
                save()
                return true
            } else {
                return false
            }
        }
    }

    private func isAlreadyInRecent(_ value: Double) -> Bool {
        for spot in stack.compactMap( { $0 } ){
            if value == spot.value {
                // this value is already in the recents list
                return true
            }
        }
        // we didn't find any value matching for the answer is no
        return false
    }
    
    private func switchTo(_ value: Double) {
        for (index, spot) in stack.enumerated() {
            if let spot = spot {
                if spot.value == value {
                    currentIndex = index
                }
            }
        }
        save()
    }
    
    /// Push a new value onto the recents stack
    ///
    /// - Parameters:
    ///   - newValue: value to be added
    ///   - type: type of the value
    func push(_ newValue: Double, with type: RecentType) {
        // first we check if the value is already in our recents
        if isAlreadyInRecent(newValue) {
            // and if so we just make that the current value
            switchTo(newValue)
        } else {
            // otherwise we push the new value on the stack
            // we make room at index 0 by moving each value to the next position
            for i in (1...max).reversed() {
                stack[i] = stack[i - 1]
            }
            // then we set the new value at index 0
            stack[0] = Spot(value: newValue, type: type)
            // and reset the current position at 0
            currentIndex = 0
            save()
        }
    }
    
    func current() -> Spot? {
        return stack[ currentIndex ]
    }
    
    func setCurrent(to index: Int)  {
        if index >= 0 && index <= max {
            currentIndex = index
            save()
        }
    }
    
    func valueFor(_ row: Int) -> Double? {
        if let spot = stack[ row ] {
            return spot.value
        } else {
            return nil
        }
    }
    
    func typeFor(_ row: Int) -> RecentType? {
        if let spot = stack [ row ] {
            return spot.type
        } else {
            return nil
        }
    }
    
    func count() -> Int {
        return stack.compactMap{ $0 }.count
    }
    
    func compact() {
        let nonNilValues = stack.compactMap { $0 }
        stack = nonNilValues
        let missing = max - stack.count + 1
        if missing > 0 {
            for _ in 1...missing {
                stack.append(nil)
            }
        }
    }
    
    func remove(at index: Int) {
        if index == currentIndex && index > count() - 2 {
            currentIndex = count() - 2 >= 0 ? count() - 2 : 0
        }
        stack.remove(at: index)
        compact()
    }
    
    // MARK: - saving/loading from disk
    func save() {
        let noValue: Double = -1.0
        for (index, spot) in stack.enumerated() {
            let valueKey = "\(key)_value_\(index)"
            let typeKey = "\(key)_type_\(index)"
            if let spot = spot {
                UserDefaults.standard.set(spot.value, forKey: valueKey)
                UserDefaults.standard.set(spot.type.rawValue, forKey: typeKey)
            } else {
                UserDefaults.standard.set(noValue, forKey: valueKey)
                UserDefaults.standard.set(noValue, forKey: typeKey)
            }
        }
        let currentKey = "\(key)_current"
        UserDefaults.standard.set(currentIndex, forKey: currentKey)
    }
    
    func load(with key: String) {
//        var noDataOnDisk = false
        stack.removeAll()
        let noValue: Double = -1.0
        for index in 0...max {
            let valueKey = "\(key)_value_\(index)"
            let typeKey = "\(key)_type_\(index)"
            let value = UserDefaults.standard.double(forKey: valueKey)
            let typeIndex = UserDefaults.standard.integer(forKey: typeKey)
            if value == noValue || value == 0.0 {
//                if index == 0 {
//                    noDataOnDisk = true
//                }
                stack.append(nil)
            } else {
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
                let spot = Spot(value: value, type: type)
                stack.append(spot)
            }
        }
        let currentKey = "\(key)_current"
        currentIndex = UserDefaults.standard.integer(forKey: currentKey)
    }
}

extension Recents {
    static let mockWavelengths = Recents(for: .wavelength, with: Constants.recentsSignalsKey)
    static let mockShiftInCm = Recents(for: .shiftInCm, with: Constants.recentsShiftsKey)
    static let mockShiftInGhz = Recents(for: .shiftInGhz, with: Constants.recentsShiftsKey)
    static let mockShiftInMev = Recents(for: .shiftInMev, with: Constants.recentsShiftsKey)
    static let mockBandwidthInCm = Recents(for: .bandwidthInCm, with: Constants.recentsBandwidthsKey)
    static let mockBandwidthInGhz = Recents(for: .bandwidthInGhz, with: Constants.recentsBandwidthsKey)
    static let mockBandwidthInNm = Recents(for: .bandwidthInNm, with: Constants.recentsBandwidthsKey)

}
