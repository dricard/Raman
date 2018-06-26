//
//  Screen.swift
//  Raman
//
//  Created by Denis Ricard on 2018-06-26.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import UIKit

struct Screen {
    var width = String(describing: UIScreen.main.bounds.width)
    var height = String(describing: UIScreen.main.bounds.height)
}

extension Screen {
    static let mock = Screen(width: "356", height: "700")
}
