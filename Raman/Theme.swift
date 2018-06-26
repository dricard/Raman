//
//  Theme.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Theme {
    
    static func color(for element: Element, with selectedTheme: ThemeModes) -> UIColor {
        switch selectedTheme {
        case .darkMode:
            switch element {
            case .displayTextColor: return UIColor(red:0.21, green:0.52, blue:0.70, alpha:1.00)
            case .swipeActionColor: return UIColor(red:0.67, green:0.80, blue:0.87, alpha:1.00)
            }
        case .lightMode:
            switch element {
            case .displayTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .swipeActionColor: return UIColor(red:0.67, green:0.80, blue:0.87, alpha:1.00)
            }
        }
    }
    

    enum Element {
        case displayTextColor
        case swipeActionColor
     }
    
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

