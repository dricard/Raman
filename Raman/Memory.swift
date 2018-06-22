//
//  Memory.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-19.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

func <<(lhs:Int, rhs:Int) -> Int {
    if lhs == 0 {
        return 9
    } else {
        return lhs - 1
    }
}

func >>(lhs:Int, rhs:Int) -> Int {
    if lhs == 9 {
        return 0
    } else {
        return lhs + 1
    }
}

struct MemoryContainer {
    let memoryRange = 0...9
    typealias parameter = Int
    typealias memorySlot = Int
    typealias dataSource = String
    typealias memoryArray = [memorySlot:Double]
    typealias memorySpace = [parameter:memoryArray]
    
    private var storageFor = [dataSource:memorySpace]()

    func storedValue(at index: Int, for parameter: Int, of dataSource: String) -> Double {
        if let value = storageFor[dataSource]?[parameter]?[index] {
            return value
        } else {
            return 0.0
        }
    }
    
    mutating func store(_ value: Double, at index: Int, for parameter: Int, of dataSource: String) {
        storageFor[dataSource]![parameter]![index] = value
    }
}

class Memory {
 
    let memoryRange = 0...9
    
    // defined types (for readability)
    typealias Parameter = Int                           // which parameter in either spectroscopy or bandwidth
    typealias MemorySlot = Int                          // which memory container
    typealias DataSource = Raman.DataSourceType         // which dataSource (either spectroscopy or bandwidth)
    typealias MemorySpace = [Parameter:MemoryArray]     // this is the array of memoryArray for a given
                                                        // dataSource (either spectroscopy or bandwidth)
    typealias MemoryArray = [MemorySlot:Double]         // for a given parameter in a dataSource, this is the
                                                        // array of saved values
    
    private var storageFor = [DataSource:MemorySpace]()
    var currentSelection = [Raman.DataSourceType:[Parameter:MemorySlot]]()

    func storedValue(at index: MemorySlot, for parameter: Parameter, of dataSource: DataSource) -> Double {
        if let value = storageFor[dataSource]?[parameter]?[index] {
            return value
        } else {
            return 0.0
        }
    }
    
    func store(_ value: Double, at index: Int, for parameter: Int, of dataSource: Raman.DataSourceType) {
        storageFor[dataSource]![parameter]![index] = value
    }
    
    init() {
        self.storageFor = [Raman.DataSourceType:[Int:[Int:Double]]]()
        self.currentSelection = [Raman.DataSourceType:[Parameter:MemorySlot]]()
        let emptyMemorySlot = [Parameter:MemorySlot]()
        self.currentSelection[Raman.DataSourceType.bandwidth] = emptyMemorySlot
        self.currentSelection[Raman.DataSourceType.spectroscopy] = emptyMemorySlot
        
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in memoryRange {
                self.storageFor[Raman.DataSourceType.spectroscopy] = [Int:[Int:Double]]()
                self.storageFor[Raman.DataSourceType.spectroscopy]![index] = [Int:Double]()
                self.storageFor[Raman.DataSourceType.spectroscopy]![index]![memorySlot] = 0.0
                self.currentSelection[Raman.DataSourceType.spectroscopy]![index] = 0
            }
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in memoryRange {
                self.storageFor[Raman.DataSourceType.bandwidth] = [Int:[Int:Double]]()
                self.storageFor[Raman.DataSourceType.bandwidth]![index] = [Int:Double]()
                self.storageFor[Raman.DataSourceType.bandwidth]![index]![memorySlot] = 0.0
                self.currentSelection[Raman.DataSourceType.bandwidth]![index] = 0
            }
        }
    }
    
    func addTo(dataSource: Raman.DataSourceType, parameter: Int, memorySlot: Int, value: Double) {
        if storageFor[dataSource] == nil {
            storageFor[dataSource] = [Int:[Int:Double]]()
        }
        if storageFor[dataSource]![parameter] == nil {
            storageFor[dataSource]![parameter] = [Int:Double]()
        }
        storageFor[dataSource]![parameter]![memorySlot] = value
    }
    
    func retrieveFrom(dataSource: Raman.DataSourceType, parameter: Int, memorySlot: Int) -> Double {
        if let value = storageFor[dataSource]![parameter]![memorySlot] {
            return value
        } else {
            return 0.0
        }
    }
    
    func previous(dataSource: Raman.DataSourceType, parameter: Int) -> Double {
        guard let selection = currentSelection[dataSource]?[parameter] else {
            return 0.0
        }
        var index = selection << 1
        var returned = retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: index)
        while index != selection && returned == 0.0 {
            index = index << 1
            returned = retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: index)
        }
        currentSelection[dataSource]![parameter]! = index
        return returned
    }

    func next(dataSource: Raman.DataSourceType, parameter: Int) -> Double {
        guard let selection = currentSelection[dataSource]?[parameter] else {
            return 0.0
        }
        var index = selection >> 1
        var returned = retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: index)
        while index != selection && returned == 0.0 {
            index = index >> 1
            returned = retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: index)
        }
        currentSelection[dataSource]![parameter]! = index
        return returned
    }

    func clearMemoryFor(dataSource: Raman.DataSourceType, parameter: Int) {
        for memorySlot in 0...9 {
            addTo(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot, value: 0.0)
        }
    }
    
    func display(dataSource: Raman.DataSourceType, parameter: Int) -> String {
        var memoryString = ""
        for i in memoryRange {
            if let value = storageFor[dataSource]?[parameter]?[i] {
                memoryString += "\(i): \(value)\n"
            } else {
                memoryString += "\(i):\n"
            }
        }
        return memoryString
    }
    
    func memoryArray(dataSource: Raman.DataSourceType, parameter: Int) -> [Double] {
        var mems = [Double]()
        for i in memoryRange {
            if let value = storageFor[dataSource]?[parameter]?[i] {
                mems.append(value)
            } else {
                mems.append(0.0)
            }
        }
        return mems
    }
    
    func saveMemoryToDisk() {
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in memoryRange {
                let value = retrieveFrom(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot)
                let key = "\(Raman.DataSourceType.spectroscopy)\(index)\(memorySlot)"
                UserDefaults.standard.set(value, forKey: key)
            }
            let key = "\(Raman.DataSourceType.spectroscopy)currentIndexFor\(index)"
            UserDefaults.standard.set(currentSelection[Raman.DataSourceType.spectroscopy]![index], forKey: key)
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in memoryRange {
                let value = retrieveFrom(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot)
                let key = "\(Raman.DataSourceType.bandwidth)\(index)\(memorySlot)"
                UserDefaults.standard.set(value, forKey: key)
            }
            let key = "\(Raman.DataSourceType.bandwidth)currentIndexFor\(index)"
            UserDefaults.standard.set(currentSelection[Raman.DataSourceType.bandwidth]![index], forKey: key)
       }
    }

    func getMemoryFromDisk() {
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in memoryRange {
                let key = "\(Raman.DataSourceType.spectroscopy)\(index)\(memorySlot)"
                let value = UserDefaults.standard.double(forKey: key)
                if value != 0 {
                    addTo(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot, value: value)
                } else {
                    addTo(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot, value: 0.0)
                }
            }
            let key = "\(Raman.DataSourceType.spectroscopy)currentIndexFor\(index)"
            currentSelection[Raman.DataSourceType.spectroscopy]![index] = UserDefaults.standard.integer(forKey: key)
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in memoryRange {
                let key = "\(Raman.DataSourceType.bandwidth)\(index)\(memorySlot)"
                let value = UserDefaults.standard.double(forKey: key)
                if value != 0 {
                    addTo(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot, value: value)
                } else {
                    addTo(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot, value: 0.0)
                }
            }
            let key = "\(Raman.DataSourceType.bandwidth)currentIndexFor\(index)"
            currentSelection[Raman.DataSourceType.bandwidth]![index] = UserDefaults.standard.integer(forKey: key)
        }
    }

}
