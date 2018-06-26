//
//  Theme.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Theme {
        
    enum Fonts {
        case titleFont
        case detailTextFont
        case navTitleFont
        
        var font: UIFont {
            switch self {
            case .titleFont: return UIFont(name: "Hack-Bold", size: 32)!
            case .detailTextFont: return UIFont.systemFont(ofSize: CGFloat(18))
            case .navTitleFont: return UIFont(name: "Hack-Bold", size: 18)!
            }
        }
    }
    
}

