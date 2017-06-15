//
//  Theme.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

struct Theme {
    
    enum ThemeModes {
        case darkMode
        case lightMode
    }
    
    var selecteTheme: ThemeModes = .darkMode
    
    static func elementColor(for element: Colors, with selectedTheme: ThemeModes) -> UIColor {
        switch selectedTheme {
        case .darkMode:
            switch element {
            case .tintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .backgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            case .sectionHeader: return UIColor(red:0.36, green:0.79, blue:0.96, alpha:1.00)
            case .foreground: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)
            case .cellTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .cellBackgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            }
        case .lightMode:
            switch element {
            case .tintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .backgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            case .sectionHeader: return UIColor(red:0.36, green:0.79, blue:0.96, alpha:1.00)
            case .foreground: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)
            case .cellTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .cellBackgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)
            }
        }
    }
    
    /*
     .tintColor: This is the NavBar text color
     .backgroundColor: this is the color behind the cells
     .sectionHeader: SectionHeader is just that, seaction headers in tables
     .foreground: Navbar background color
     .cellBackgroud: cell background
     .cellTextColor: cell text color
     
 */
    enum Colors {
        case tintColor
        case backgroundColor
        case cellBackgroundColor
        case sectionHeader
        case foreground
        case cellTextColor
        
        var color: UIColor {
            switch self {
            case .tintColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)        // This is the NavBar text color
            // Background color is used for window background
            case .backgroundColor: return UIColor(red:0.29, green:0.62, blue:0.80, alpha:1.00)  // this is the color behind the cells
            // SectionHeader is just that, seaction headers in tables
            case .sectionHeader: return UIColor(red:0.36, green:0.79, blue:0.96, alpha:1.00)
            // Foreground is used for Nav bar
            case .foreground: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)       // cell background and Navbar background color
            case .cellTextColor: return UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
            case .cellBackgroundColor: return UIColor(red:0.62, green:0.82, blue:0.90, alpha:0.25)
            }
        }
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

