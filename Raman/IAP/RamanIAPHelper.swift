//
//  RamanIAPHelper.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-16.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

enum RamanIAPHelper: String {
    case memories = "memories"
    
    var productId: String {
        return (Bundle.main.bundleIdentifier ?? "") + "." + rawValue
    }
    
    init?(productId: String) {
        guard let bundleID = Bundle.main.bundleIdentifier, productId.hasPrefix(bundleID) else { return nil }
        self.init(rawValue: productId.replacingOccurrences(of: bundleID + ".", with: ""))
    }
}
