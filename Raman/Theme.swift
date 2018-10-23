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
        case valueFont
        case detailTextFont
        case unitsFont
        case navTitleFont
        case exponentFont
        
        var font: UIFont {
            switch self {
            case .titleFont: return UIFont.systemFont(ofSize: 32, weight: .heavy)
            case .valueFont: return UIFont.systemFont(ofSize: 42, weight: .heavy)
            case .subTitleFont: return UIFont.systemFont(ofSize: 24, weight: .heavy)
            case .detailTextFont: return UIFont.italicSystemFont(ofSize: CGFloat(14))
            case .unitsFont: return UIFont.systemFont(ofSize: CGFloat(16))
            case .navTitleFont: return UIFont.systemFont(ofSize: 18, weight: .bold)
            case .exponentFont: return UIFont.systemFont(ofSize: CGFloat(10))
            }
        }
    }
    
}

