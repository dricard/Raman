//
//  Device.swift
//  Raman
//
//  Created by Denis Ricard on 2018-06-26.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import UIKit

struct Device {
    var systemName = UIDevice.current.systemName
    var systemVersion = UIDevice.current.systemVersion
}

extension Device {
    static let mock = Device(systemName: "Mock OS", systemVersion: "0.1")
}
