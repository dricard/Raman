//
//  Theme.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Theme {
    enum Colors {
        case TintColor
        case BackgroundColor
        case SectionHeader
        case Foreground
        case LightTextColor
        case DarkBackgroundColor
        
        var color: UIColor {
            switch self {
            case .TintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)        // This is the NavBar text color
            // Background color is used for window background
            case .BackgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)  // this is the color behind the cells
            // SectionHeader is just that, seaction headers in tables
            case .SectionHeader: return UIColor(red:0.36, green:0.79, blue:0.96, alpha:1.00)
            // Foreground is used for Nav bar
            case .Foreground: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:1.00)       // cell background and Navbar background color
            case .LightTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .DarkBackgroundColor: return UIColor(red:0.21, green:0.52, blue:0.70, alpha:1.00)
            }
        }
    }
    
    enum Fonts {
        case TitleFont
        case DetailTextFont
        case NavTitleFont
        
        var font: UIFont {
            switch self {
            case .TitleFont: return UIFont(name: "Hack-Bold", size: 32)!
            case .DetailTextFont: return UIFont.systemFontOfSize(CGFloat(18))
            case .NavTitleFont: return UIFont(name: "Hack-Bold", size: 18)!
            }
        }
    }

}

