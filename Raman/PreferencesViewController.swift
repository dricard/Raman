//
//  PreferencesViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    // MARK: - Properties
    
    var Current: Environment?
    
    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var lightThemeLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var lightSwitchLabel: UILabel!
    @IBOutlet weak var darkSwitchLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    
    @IBOutlet weak var light_set_0_button: UIButton!
    @IBOutlet weak var light_set_1_button: UIButton!
    @IBOutlet weak var light_set_2_button: UIButton!
    @IBOutlet weak var light_set_3_button: UIButton!
    @IBOutlet weak var light_set_4_button: UIButton!
    
    @IBOutlet weak var dark_set_0_button: UIButton!
    @IBOutlet weak var dark_set_1_button: UIButton!
    @IBOutlet weak var dark_set_2_button: UIButton!
    @IBOutlet weak var dark_set_3_button: UIButton!
    @IBOutlet weak var dark_set_4_button: UIButton!
    @IBOutlet weak var keyClickLabel: UILabel!
    @IBOutlet weak var keyClickSwitch: UISwitch!
    
    
    // MARK: - actions
    private func colorChanged(for currentMode: ThemeModes, animated: Bool) {
        guard let Current = Current else { return }

        Current.colorSet.save()
        updateDisplay()
        changeDisplayColors(for: currentMode, animated: animated)

    }
    
    @IBAction func light_set_0_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set0
        colorChanged(for: .light, animated: true)
    }
    @IBAction func light_set_1_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set1
        colorChanged(for: .light, animated: true)
    }
    @IBAction func light_set_2_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set2
        colorChanged(for: .light, animated: true)
    }
    @IBAction func light_set_3_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set3
        colorChanged(for: .light, animated: true)
    }
    @IBAction func light_set_4_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set4
        colorChanged(for: .light, animated: true)
    }
    
    @IBAction func dark_set_0_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.darkSet = .set0
        colorChanged(for: .dark, animated: true)
  }
    @IBAction func dark_set_1_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.darkSet = .set1
        colorChanged(for: .dark, animated: true)
    }
    @IBAction func dark_set_2_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.darkSet = .set2
        colorChanged(for: .dark, animated: true)
    }
    @IBAction func dark_set_3_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.darkSet = .set3
        colorChanged(for: .dark, animated: true)
    }
    @IBAction func dark_set_4_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.darkSet = .set4
        colorChanged(for: .dark, animated: true)
   }
    
    @IBAction func themeSwitchPressed(_ sender: Any) {
        if let Current = Current {
            Current.colorSet.toggle()
            Current.colorSet.save()
            changeDisplayColors(for: Current.colorSet.mode, animated: true)
        }
    }
    
    @IBAction func keyClickSwitchPressed(_ sender: UISwitch) {
        guard let Current = Current else { return }
        UserDefaults.standard.set(sender.isOn, forKey: Current.keyClicksKey)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .aboutRaman
        doneButton.title = .doneButton
        instructionsLabel.text = .preferencesInstructions
        creditsLabel.text = .credits
        lightThemeLabel.text = String.lightThemeLabel
        darkThemeLabel.text = String.darkThemeLabel
        lightSwitchLabel.text = String.lightSwitchName
        darkSwitchLabel.text = String.darkSwitchName
        keyClickLabel.text = String.keyClickSwitchName
        
        helpButton.setTitle(.helpButton, for: .normal)
        supportButton.setTitle(.supportButton, for: .normal)

        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"
        
        view.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
        
        updateDisplay()
        if let Current = Current {
            versionNumberLabel.text = "v. " + Current.version.release + " (" + Current.version.build + ")"
            changeDisplayColors(for: Current.colorSet.mode , animated: false)
            themeSwitch.isOn = Current.colorSet.mode == .dark
            keyClickSwitch.isOn = UserDefaults.standard.bool(forKey: Current.keyClicksKey)
        }

     }
    
    // MARK: - User actions
    
    @IBAction func logoPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://hexaedre.com")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func helpPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://hexaedre.com/apps/raman/")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func supportPressed(_ sender: AnyObject) {
        if let url = URL(string: "mailto:dr@hexaedre.com?subject=Raman%20App%20support%20request&body=Please%20ask%20your%20quetion%20or%20make%20your%20comment%20here.%20Thank%20you!")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func userPressedDone(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Utilities
    
    func changeDisplayColors(for currentMode:  ThemeModes, animated: Bool) {
        guard let Current = Current,  currentMode == Current.colorSet.mode else { return }

        if animated {
            UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {
                
                // set navigation bar
                self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
                self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")!]
                self.view.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")
                self.darkThemeLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
                self.lightThemeLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
                self.lightSwitchLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
                self.darkSwitchLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
                self.themeSwitch.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")
                self.keyClickSwitch.backgroundColor = UIColor(named:  "\(Current.colorSet.prefix())cellBackgroundColor")
                self.keyClickLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
                
                self.helpButton.titleLabel?.textColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
                self.helpButton.layer.backgroundColor = UIColor(named:"\(Current.colorSet.prefix())navBarTintColor")!.cgColor
                self.helpButton.layer.cornerRadius = 8
                self.helpButton.layer.borderWidth = 2
                self.helpButton.layer.borderColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")!.cgColor

                self.supportButton.titleLabel?.textColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
                self.supportButton.layer.backgroundColor = UIColor(named:"\(Current.colorSet.prefix())navBarTintColor")!.cgColor
                self.supportButton.layer.cornerRadius = 8
                self.supportButton.layer.borderWidth = 2
                self.supportButton.layer.borderColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")!.cgColor

            }, completion: nil)
        } else {
            // set navigation bar
            navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")!]
            view.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")
            darkThemeLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            lightThemeLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            lightSwitchLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            darkSwitchLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            themeSwitch.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")
            keyClickSwitch.backgroundColor = UIColor(named:  "\(Current.colorSet.prefix())cellBackgroundColor")
            keyClickLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")

            // style buttons
            helpButton.titleLabel?.textColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            helpButton.layer.backgroundColor = UIColor(named:"\(Current.colorSet.prefix())navBarTintColor")!.cgColor
            helpButton.layer.cornerRadius = 8
            helpButton.layer.borderWidth = 2
            helpButton.layer.borderColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")!.cgColor
            
            supportButton.titleLabel?.textColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            supportButton.layer.backgroundColor = UIColor(named:"\(Current.colorSet.prefix())navBarTintColor")!.cgColor
            supportButton.layer.cornerRadius = 8
            supportButton.layer.borderWidth = 2
            supportButton.layer.borderColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")!.cgColor

        }
    }
    
    func updateDisplay() {
        
        guard let Current = Current else { return }
        
        light_set_0_button.backgroundColor = UIColor(named: "0_light_navBarTintColor")
        light_set_1_button.backgroundColor = UIColor(named: "1_light_navBarTintColor")
        light_set_2_button.backgroundColor = UIColor(named: "2_light_navBarTintColor")
        light_set_3_button.backgroundColor = UIColor(named: "3_light_navBarTintColor")
        light_set_4_button.backgroundColor = UIColor(named: "4_light_navBarTintColor")

        switch Current.colorSet.lightSet.rawValue {
        case 0:
            light_set_0_button.layer.borderColor = UIColor.black.cgColor
            light_set_0_button.layer.borderWidth = 5
            light_set_0_button.layer.cornerRadius = 8
            light_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_1_button.layer.borderWidth = 3
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_2_button.layer.borderWidth = 3
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_3_button.layer.borderWidth = 3
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_4_button.layer.borderWidth = 3
            light_set_4_button.layer.cornerRadius = 0
        case 1:
            light_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_0_button.layer.borderWidth = 3
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.black.cgColor
            light_set_1_button.layer.borderWidth = 5
            light_set_1_button.layer.cornerRadius = 8
            light_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_2_button.layer.borderWidth = 3
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_3_button.layer.borderWidth = 3
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_4_button.layer.borderWidth = 3
            light_set_4_button.layer.cornerRadius = 0
        case 2:
            light_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_0_button.layer.borderWidth = 3
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_1_button.layer.borderWidth = 3
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.black.cgColor
            light_set_2_button.layer.borderWidth = 5
            light_set_2_button.layer.cornerRadius = 8
            light_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_3_button.layer.borderWidth = 3
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_4_button.layer.borderWidth = 3
            light_set_4_button.layer.cornerRadius = 0
        case 3:
            light_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_0_button.layer.borderWidth = 3
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_1_button.layer.borderWidth = 3
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_2_button.layer.borderWidth = 3
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.black.cgColor
            light_set_3_button.layer.borderWidth = 5
            light_set_3_button.layer.cornerRadius = 8
            light_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_4_button.layer.borderWidth = 3
            light_set_4_button.layer.cornerRadius = 0
        case 4:
            light_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_0_button.layer.borderWidth = 3
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_1_button.layer.borderWidth = 3
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_2_button.layer.borderWidth = 3
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_3_button.layer.borderWidth = 3
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.black.cgColor
            light_set_4_button.layer.borderWidth = 5
            light_set_4_button.layer.cornerRadius = 8
        default:
            light_set_0_button.layer.borderColor = UIColor.black.cgColor
            light_set_0_button.layer.borderWidth = 5
            light_set_0_button.layer.cornerRadius = 8
            light_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_1_button.layer.borderWidth = 3
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_2_button.layer.borderWidth = 3
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_3_button.layer.borderWidth = 3
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            light_set_4_button.layer.borderWidth = 3
            light_set_4_button.layer.cornerRadius = 0
       }
        
        dark_set_0_button.backgroundColor = UIColor(named: "0_dark_navBarTintColor")
        dark_set_1_button.backgroundColor = UIColor(named: "1_dark_navBarTintColor")
        dark_set_2_button.backgroundColor = UIColor(named: "2_dark_navBarTintColor")
        dark_set_3_button.backgroundColor = UIColor(named: "3_dark_navBarTintColor")
        dark_set_4_button.backgroundColor = UIColor(named: "4_dark_navBarTintColor")

        switch Current.colorSet.darkSet.rawValue {
        case 0:
            dark_set_0_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_0_button.layer.borderWidth = 5
            dark_set_0_button.layer.cornerRadius = 8
            dark_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_1_button.layer.borderWidth = 3
            dark_set_1_button.layer.cornerRadius = 0
            dark_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_2_button.layer.borderWidth = 3
            dark_set_2_button.layer.cornerRadius = 0
            dark_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_3_button.layer.borderWidth = 3
            dark_set_3_button.layer.cornerRadius = 0
            dark_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_4_button.layer.borderWidth = 3
            dark_set_4_button.layer.cornerRadius = 0
        case 1:
            dark_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_0_button.layer.borderWidth = 3
            dark_set_0_button.layer.cornerRadius = 0
            dark_set_1_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_1_button.layer.borderWidth = 5
            dark_set_1_button.layer.cornerRadius = 8
            dark_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_2_button.layer.borderWidth = 3
            dark_set_2_button.layer.cornerRadius = 0
            dark_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_3_button.layer.borderWidth = 3
            dark_set_3_button.layer.cornerRadius = 0
            dark_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_4_button.layer.borderWidth = 3
            dark_set_4_button.layer.cornerRadius = 0
        case 2:
            dark_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_0_button.layer.borderWidth = 3
            dark_set_0_button.layer.cornerRadius = 0
            dark_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_1_button.layer.borderWidth = 3
            dark_set_1_button.layer.cornerRadius = 0
            dark_set_2_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_2_button.layer.borderWidth = 5
            dark_set_2_button.layer.cornerRadius = 8
            dark_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_3_button.layer.borderWidth = 3
            dark_set_3_button.layer.cornerRadius = 0
            dark_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_4_button.layer.borderWidth = 3
            dark_set_4_button.layer.cornerRadius = 0
        case 3:
            dark_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_0_button.layer.borderWidth = 3
            dark_set_0_button.layer.cornerRadius = 0
            dark_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_1_button.layer.borderWidth = 3
            dark_set_1_button.layer.cornerRadius = 0
            dark_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_2_button.layer.borderWidth = 3
            dark_set_2_button.layer.cornerRadius = 0
            dark_set_3_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_3_button.layer.borderWidth = 5
            dark_set_3_button.layer.cornerRadius = 8
            dark_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_4_button.layer.borderWidth = 3
            dark_set_4_button.layer.cornerRadius = 0
        case 4:
            dark_set_0_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_0_button.layer.borderWidth = 3
            dark_set_0_button.layer.cornerRadius = 0
            dark_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_1_button.layer.borderWidth = 3
            dark_set_1_button.layer.cornerRadius = 0
            dark_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_2_button.layer.borderWidth = 3
            dark_set_2_button.layer.cornerRadius = 0
            dark_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_3_button.layer.borderWidth = 3
            dark_set_3_button.layer.cornerRadius = 0
            dark_set_4_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_4_button.layer.borderWidth = 5
            dark_set_4_button.layer.cornerRadius = 8
        default:
            dark_set_0_button.layer.borderColor = UIColor.lightGray.cgColor
            dark_set_0_button.layer.borderWidth = 5
            dark_set_0_button.layer.cornerRadius = 8
            dark_set_1_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_1_button.layer.borderWidth = 3
            dark_set_1_button.layer.cornerRadius = 0
            dark_set_2_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_2_button.layer.borderWidth = 3
            dark_set_2_button.layer.cornerRadius = 0
            dark_set_3_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_3_button.layer.borderWidth = 3
            dark_set_3_button.layer.cornerRadius = 0
            dark_set_4_button.layer.borderColor = UIColor.darkGray.cgColor
            dark_set_4_button.layer.borderWidth = 3
            dark_set_4_button.layer.cornerRadius = 0
        }

    }
}
