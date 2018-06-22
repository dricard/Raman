//
//  AppDelegate.swift
//  Raman
//
//  Created by Denis Ricard on 2015-05-20.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var raman = Raman()
    var selectedTheme = ThemeMode()
    var memory = Memory()
    
    fileprivate func loadUserPrefs() {
        // Load user's data
        
        let signal = UserDefaults.standard.double(forKey: "signal")
        if signal != 0 {
            raman.signal = signal
        } else {
            UserDefaults.standard.set(raman.signal, forKey: "signal")
        }
        let pump = UserDefaults.standard.double(forKey: "pump")
        if pump != 0 {
            raman.pump = pump
        } else {
            UserDefaults.standard.set(raman.pump, forKey: "pump")
        }
        let bwLambda = UserDefaults.standard.double(forKey: "bwLambda")
        if bwLambda != 0 {
            raman.bwLambda = bwLambda
        } else {
            UserDefaults.standard.set(raman.bwLambda, forKey: "bwLambda")
        }
        let bwInCm = UserDefaults.standard.double(forKey: "bwInCm")
        if bwInCm != 0 {
            raman.bwInCm = bwInCm
        } else {
            UserDefaults.standard.set(raman.bwInCm, forKey: "bwInCm")
        }
        memory.getMemoryFromDisk()
        
        // theme mode selected
        let mode = UserDefaults.standard.integer(forKey: "themeMode")
        if mode > 0 {
            if let theme = ThemeModes(rawValue: mode) {
                selectedTheme.mode = theme
            } else {
                selectedTheme.mode = ThemeModes.darkMode
            }
        } else {
            UserDefaults.standard.set(ThemeModes.darkMode.rawValue, forKey: "themeMode")
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadUserPrefs()
        
        window?.tintColor = Theme.color(for: .windowTintColor, with: selectedTheme.mode)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): Theme.Fonts.navTitleFont.font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
        ]
        navBarAppearance.barStyle = UIBarStyle.blackTranslucent
        navBarAppearance.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        
        // set tab bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        tabBarAppearance.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        if #available(iOS 10.0, *) {
            tabBarAppearance.unselectedItemTintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        } else {
            // Fallback on earlier versions
        }
                
        // Dependency injection
        
        guard let tabController = window?.rootViewController as? UITabBarController else { return true }
        
        for vc in tabController.childViewControllers {
            if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? ViewController {
                viewController.raman = raman
                viewController.selectedTheme = selectedTheme
                viewController.memory = memory
            } else if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? BandwidthViewController {
                viewController.raman = raman
                viewController.selectedTheme = selectedTheme
                viewController.memory = memory
            }
        }
        
        return true
    }
    
}

