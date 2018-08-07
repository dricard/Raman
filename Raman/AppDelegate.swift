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
        
        Current.bandwidths.load(with: Constants.recentsBandwidthsKey)
        if Current.bandwidths.isEmpty {
            Current.bandwidths.push(70.00, with: .shiftInCm)
            Current.bandwidths.isEmpty = false
        }
        if let spot = Current.bandwidths.current() {
            Current.raman.updateParameter(spot.value, forDataSource: spot.type.rawValue - 3, inWhichTab: .bandwidth)
        }

        Current.excitations.load(with: Constants.recentsExcitationKey)
        if Current.excitations.isEmpty {
            Current.excitations.push(532.00, with: .wavelength)
            Current.excitations.isEmpty = false
        }
        if let spot = Current.excitations.current() {
            Current.raman.updateParameter(spot.value, forDataSource: Constants.excitationIndex, inWhichTab: .spectroscopy)
        }
        Current.shifts.load(with: Constants.recentsShiftsKey)
        if Current.shifts.isEmpty {
            Current.shifts.push(70.00, with: .shiftInCm)
            Current.shifts.isEmpty = false
        }
        if let spot = Current.shifts.current() {
            Current.raman.updateParameter(spot.value, forDataSource: spot.type.rawValue + 1, inWhichTab: .spectroscopy)
        }
        Current.signals.load(with: Constants.recentsSignalsKey)
        if Current.signals.isEmpty {
            Current.signals.push(533.99, with: .wavelength)
            Current.signals.isEmpty = false
            Current.raman.signal = 533.99
        }
        if let spot = Current.signals.current() {
            Current.raman.updateParameter(spot.value, forDataSource: Constants.signalIndex, inWhichTab: .spectroscopy)
        }
        
        Current.colorSet.load()
        
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
        navBarAppearance.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
        
        // set tab bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
        tabBarAppearance.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
        tabBarAppearance.unselectedItemTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")

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

