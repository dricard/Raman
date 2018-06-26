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
//            case .windowTintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .navBarTextColor: return UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
            case .navBarUnselectedTextColor: return UIColor(red:0.00, green:0.01, blue:0.06, alpha:0.40)
            case .tableViewBackgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            case .tableViewSeparatorColor: return UIColor(red:1.00, green:0.97, blue:0.85, alpha:1.00)
            case .navBarTintColor: return UIColor(red:0.21, green:0.52, blue:0.70, alpha:1.00)
            case .cellTextColor: return UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
            case .cellBackgroundColor: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)
            case .displayBackgroundColor: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:1.0)
            case .displayTextColor: return UIColor(red:0.21, green:0.52, blue:0.70, alpha:1.00)
            case .swipeActionColor: return UIColor(red:0.67, green:0.80, blue:0.87, alpha:1.00)
            }
        case .lightMode:
            switch element {
//            case .windowTintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .navBarUnselectedTextColor: return UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.00)
            case .navBarTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .tableViewBackgroundColor: return UIColor(red:1.00, green:0.97, blue:0.85, alpha:1.00)
            case .tableViewSeparatorColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            case .navBarTintColor: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)
            case .cellTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .cellBackgroundColor: return UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
            case .displayBackgroundColor: return UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
            case .displayTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .swipeActionColor: return UIColor(red:0.67, green:0.80, blue:0.87, alpha:1.00)
            }
        }
    }
    
    /*
     .windowTintColor: window color
     .navBarTextColor: text in the navigation bar
     .tableViewBackgroundColor: this is the color behind the cells
     .tableViewSeparatorColor: this is the color between the cells (usually same as background)
     .cellBackgroundColor: cell background
     .navBarTintColor: Navbar background color
     .cellTextColor: cell text color
    */
    enum Element {
//        case windowTintColor
        case navBarTextColor
        case navBarUnselectedTextColor
        case tableViewBackgroundColor
        case tableViewSeparatorColor
        case cellBackgroundColor
        case navBarTintColor
        case cellTextColor
        case displayBackgroundColor
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

