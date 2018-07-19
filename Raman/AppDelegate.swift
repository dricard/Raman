//
//  AppDelegate.swift
//  Raman
//
//  Created by Denis Ricard on 2015-05-20.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit
import StoreKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var Current = Environment()
    
    fileprivate func loadUserPrefs() {
        // Load user's data
        
//        let signal = UserDefaults.standard.double(forKey: "signal")
//        if signal != 0 {
//            Current.raman.signal = signal
//        } else {
//            UserDefaults.standard.set(Current.raman.signal, forKey: "signal")
//        }
//        let pump = UserDefaults.standard.double(forKey: "pump")
//        if pump != 0 {
//            Current.raman.pump = pump
//        } else {
//            UserDefaults.standard.set(Current.raman.pump, forKey: "pump")
//        }
//        let bwLambda = UserDefaults.standard.double(forKey: "bwLambda")
//        if bwLambda != 0 {
//            Current.raman.bwLambda = bwLambda
//        } else {
//            UserDefaults.standard.set(Current.raman.bwLambda, forKey: "bwLambda")
//        }
//        let bwInCm = UserDefaults.standard.double(forKey: "bwInCm")
//        if bwInCm != 0 {
//            Current.raman.bwInCm = bwInCm
//        } else {
//            UserDefaults.standard.set(Current.raman.bwInCm, forKey: "bwInCm")
//        }
        
        Current.bandwidths.load(with: "bandwidths")
        if Current.bandwidths.isEmpty {
            Current.bandwidths.push(70.00, with: .shiftInCm)
            Current.bandwidths.isEmpty = false
        }
        if let value = Current.bandwidths.current().value {
            Current.raman.updateParameter(value, forDataSource: Current.bandwidths.current().type.rawValue - 3, inWhichTab: .bandwidth)
        }

        Current.excitations.load(with: "excitations")
        if Current.excitations.isEmpty {
            Current.excitations.push(532.00, with: .wavelength)
            Current.excitations.isEmpty = false
        }
        if let value = Current.excitations.current().value {
            Current.raman.updateParameter(value, forDataSource: 0, inWhichTab: .spectroscopy)
        }
        Current.shifts.load(with: "shifts")
        if Current.shifts.isEmpty {
            Current.shifts.push(70.00, with: .shiftInCm)
            Current.shifts.isEmpty = false
        }
        if let value = Current.shifts.current().value {
            Current.raman.updateParameter(value, forDataSource: Current.shifts.current().type.rawValue + 2, inWhichTab: .spectroscopy)
        }
        Current.signals.load(with: "signals")
        if Current.signals.isEmpty {
            Current.signals.push(533.99, with: .wavelength)
            Current.signals.isEmpty = false
            Current.raman.signal = 533.99
        }
        if let value = Current.signals.current().value {
            Current.raman.updateParameter(value, forDataSource: 1, inWhichTab: .spectroscopy)
        }
        
        // theme mode selected
        let mode = UserDefaults.standard.integer(forKey: "themeMode")
        if mode > 0 {
            if let theme = ThemeModes(rawValue: mode) {
                Current.selectedTheme.mode = theme
            } else {
                Current.selectedTheme.mode = ThemeModes.darkMode
            }
        } else {
            UserDefaults.standard.set(ThemeModes.darkMode.rawValue, forKey: "themeMode")
        }
        
        os_log("LoadUserPrefs was completed", log: Log.general, type: .info)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadUserPrefs()
        
        window?.tintColor = UIColor(named: "windowTintColor")
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): Theme.Fonts.navTitleFont.font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red:0.29, green:0.38, blue:0.42, alpha:1.00)
        ]
        navBarAppearance.barStyle = UIBarStyle.blackTranslucent
        navBarAppearance.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
        
        // set tab bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
        tabBarAppearance.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
        tabBarAppearance.unselectedItemTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")

        // Dependency injection
        
        guard let tabController = window?.rootViewController as? UITabBarController else { return true }
        
        /* FOR TESTING */
//        Current = .mock
//        UserDefaults.standard.setValue([Current.locale.representation()], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
        /* TESTING END */
        
        for vc in tabController.childViewControllers {
            if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? SpectroViewController {
                viewController.Current = Current
            } else if let navController = vc as? UINavigationController, let viewController = navController.topViewController as? BandwidthViewController {
                viewController.Current = Current
            }
        }
        
        return true
    }
    
}

