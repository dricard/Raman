//
//  Log.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-03.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation
import os.log

struct Log {
    static var general = OSLog(subsystem: "com.hexaedre.raman", category: "general")
}
