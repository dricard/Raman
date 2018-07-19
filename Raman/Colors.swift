//
//  Colors.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-19.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation

enum ColorSets: Int {
    case set0 = 0
    case set1
    case set2
    case set3
    case set4
}

struct Colors {
    
    var set: ColorSets = .set0
    
    func suffix() -> String {
        return "_set\(set.rawValue)"
    }
}

extension Colors {
    static let mock = Colors(set: .set0)
}
