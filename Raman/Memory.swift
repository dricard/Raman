//
//  Memory.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-19.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

class Memory {
 
    private var storageFor: [Raman.DataSourceType:[Int:[Int:Double]]]
    
    init() {
        self.storageFor = [Raman.DataSourceType:[Int:[Int:Double]]]()
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in 0...9 {
                self.storageFor[Raman.DataSourceType.spectroscopy] = [Int:[Int:Double]]()
                self.storageFor[Raman.DataSourceType.spectroscopy]![index] = [Int:Double]()
                self.storageFor[Raman.DataSourceType.spectroscopy]![index]![memorySlot] = 0.0
            }
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in 0...9 {
                self.storageFor[Raman.DataSourceType.bandwidth] = [Int:[Int:Double]]()
                self.storageFor[Raman.DataSourceType.bandwidth]![index] = [Int:Double]()
                self.storageFor[Raman.DataSourceType.bandwidth]![index]![memorySlot] = 0.0
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

    func clearMemoryFor(dataSource: Raman.DataSourceType, parameter: Int) {
        for memorySlot in 0...9 {
            addTo(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot, value: 0.0)
        }
    }
    func display(dataSource: Raman.DataSourceType, parameter: Int) -> String {
        var memoryString = ""
        for i in 0...9 {
            if let value = storageFor[dataSource]?[parameter]?[i] {
                memoryString += "\(i): \(value)\n"
            } else {
                memoryString += "\(i):\n"
            }
        }
        return memoryString
    }
    
    func saveMemoryToDisk() {
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in 0...9 {
                let value = retrieveFrom(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot)
                let key = "\(Raman.DataSourceType.spectroscopy)\(index)\(memorySlot)"
                UserDefaults.standard.set(value, forKey: key)
            }
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in 0...9 {
                let value = retrieveFrom(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot)
                let key = "\(Raman.DataSourceType.bandwidth)\(index)\(memorySlot)"
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }

    func getMemoryFromDisk() {
        // spectroscopy
        for (index, _) in Constants.ramanShift.enumerated() {
            for memorySlot in 0...9 {
                let key = "\(Raman.DataSourceType.spectroscopy)\(index)\(memorySlot)"
                let value = UserDefaults.standard.double(forKey: key)
                if value != 0 {
                    addTo(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot, value: value)
                } else {
                    addTo(dataSource: Raman.DataSourceType.spectroscopy, parameter: index, memorySlot: memorySlot, value: 0.0)
                }
            }
        }
        // bandwidth
        for (index, _) in Constants.ramanBandwidth.enumerated() {
            for memorySlot in 0...9 {
                let key = "\(Raman.DataSourceType.bandwidth)\(index)\(memorySlot)"
                let value = UserDefaults.standard.double(forKey: key)
                if value != 0 {
                    addTo(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot, value: value)
                } else {
                    addTo(dataSource: Raman.DataSourceType.bandwidth, parameter: index, memorySlot: memorySlot, value: 0.0)
                }
            }
        }
    }

}
