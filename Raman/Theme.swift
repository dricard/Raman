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
        case subTitleFont
        case detailTextFont
        case navTitleFont
        case exponentFont
        
        var font: UIFont {
            switch self {
            case .titleFont: return UIFont.systemFont(ofSize: 32, weight: .heavy)
            case .subTitleFont: return UIFont.systemFont(ofSize: 24, weight: .heavy)
            case .detailTextFont: return UIFont.systemFont(ofSize: CGFloat(18))
            case .navTitleFont: return UIFont.systemFont(ofSize: 18, weight: .bold)
            case .exponentFont: return UIFont.systemFont(ofSize: CGFloat(12))
            }
        }
    }
    
}

