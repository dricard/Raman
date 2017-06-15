//
//  AppDelegate.swift
//  Raman
//
//  Created by Denis Ricard on 2015-05-20.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var raman = Raman()
    var selectedTheme: Theme.ThemeModes = .lightMode
    
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
        
        // theme mode selected
        let mode = UserDefaults.standard.integer(forKey: "themeMode")
        if mode > 0 {
            if let theme = Theme.ThemeModes(rawValue: mode) {
                selectedTheme = theme
            } else {
                selectedTheme = Theme.ThemeModes.darkMode
            }
        } else {
            UserDefaults.standard.set(Theme.ThemeModes.darkMode.rawValue, forKey: "themeMode")
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = Theme.color(for: .windowTintColor, with: .darkMode)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSAttributedStringKey.font.rawValue: Theme.Fonts.navTitleFont.font,
            NSAttributedStringKey.foregroundColor.rawValue: Theme.color(for: .navBarTextColor, with: .darkMode)
        ]
        navBarAppearance.barStyle = UIBarStyle.black
        navBarAppearance.barTintColor = Theme.color(for: .navBarTintColor, with: .darkMode)
        
        Fabric.with([Crashlytics.self])
        
        loadUserPrefs()
        
        // Dependency injection
        
        guard let tabController = window?.rootViewController as? UITabBarController else { return true }
        
        for vc in tabController.childViewControllers {
            if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? ViewController {
                viewController.raman = raman
                viewController.selectedTheme = selectedTheme
            } else if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? BandwidthViewController {
                viewController.raman = raman
                viewController.selectedTheme = selectedTheme
            }
        }
        
        return true
    }
    
}

