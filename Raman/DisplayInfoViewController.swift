//
//  DisplayInfoViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class DisplayInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var Current: Environment?
    
    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!

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
    
    
    // MARK: - actions
    
    @IBAction func light_set_0_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set0
        updateDisplay()
        changeDisplayColors()
    }
    @IBAction func light_set_1_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set1
        updateDisplay()
        changeDisplayColors()
    }
    @IBAction func light_set_2_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set2
        updateDisplay()
    }
    @IBAction func light_set_3_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set3
        updateDisplay()
    }
    @IBAction func light_set_4_buttonPressed(_ sender: Any) {
        guard let Current = Current else { return }
        Current.colorSet.lightSet = .set4
        updateDisplay()
    }
    
    @IBAction func dark_set_0_buttonPressed(_ sender: Any) {
    }
    @IBAction func dark_set_1_buttonPressed(_ sender: Any) {
    }
    @IBAction func dark_set_2_buttonPressed(_ sender: Any) {
    }
    @IBAction func dark_set_3_buttonPressed(_ sender: Any) {
    }
    @IBAction func dark_set_4_buttonPressed(_ sender: Any) {
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .aboutRaman
        helpButton.setTitle(.helpButton, for: .normal)
        supportButton.setTitle(.supportButton, for: .normal)
        doneButton.title = .doneButton
        
        if let Current = Current {
            versionNumberLabel.text = "v. " + Current.version.release + " (" + Current.version.build + ")"
        }
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"
        
        view.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
        
        updateDisplay()
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
    
    func changeDisplayColors() {
        guard let Current = Current else { return }
        
        UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {
            
            // set navigation bar
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")!]
            self.view.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")
        }, completion: nil)
        
    }
    
    func updateDisplay() {
        
        guard let Current = Current else { return }
        
        light_set_0_button.backgroundColor = UIColor(named: "0_light_navBarTintColor")
        light_set_1_button.backgroundColor = UIColor(named: "1_light_navBarTintColor")

        switch Current.colorSet.lightSet.rawValue {
        case 0:
            light_set_0_button.layer.borderColor = UIColor.black.cgColor
            light_set_0_button.layer.borderWidth = 4
            light_set_0_button.layer.cornerRadius = 8
            light_set_1_button.layer.borderColor = UIColor.clear.cgColor
            light_set_1_button.layer.borderWidth = 0
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.clear.cgColor
            light_set_2_button.layer.borderWidth = 0
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.clear.cgColor
            light_set_3_button.layer.borderWidth = 0
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.clear.cgColor
            light_set_4_button.layer.borderWidth = 0
            light_set_4_button.layer.cornerRadius = 0
        case 1:
            light_set_0_button.layer.borderColor = UIColor.clear.cgColor
            light_set_0_button.layer.borderWidth = 0
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.black.cgColor
            light_set_1_button.layer.borderWidth = 4
            light_set_1_button.layer.cornerRadius = 8
            light_set_2_button.layer.borderColor = UIColor.clear.cgColor
            light_set_2_button.layer.borderWidth = 0
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.clear.cgColor
            light_set_3_button.layer.borderWidth = 0
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.clear.cgColor
            light_set_4_button.layer.borderWidth = 0
            light_set_4_button.layer.cornerRadius = 0
        case 2:
            light_set_0_button.layer.borderColor = UIColor.clear.cgColor
            light_set_0_button.layer.borderWidth = 0
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.clear.cgColor
            light_set_1_button.layer.borderWidth = 0
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.black.cgColor
            light_set_2_button.layer.borderWidth = 4
            light_set_2_button.layer.cornerRadius = 8
            light_set_3_button.layer.borderColor = UIColor.clear.cgColor
            light_set_3_button.layer.borderWidth = 0
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.clear.cgColor
            light_set_4_button.layer.borderWidth = 0
            light_set_4_button.layer.cornerRadius = 0
        case 3:
            light_set_0_button.layer.borderColor = UIColor.clear.cgColor
            light_set_0_button.layer.borderWidth = 0
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.clear.cgColor
            light_set_1_button.layer.borderWidth = 0
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.clear.cgColor
            light_set_2_button.layer.borderWidth = 0
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.black.cgColor
            light_set_3_button.layer.borderWidth = 4
            light_set_3_button.layer.cornerRadius = 8
            light_set_4_button.layer.borderColor = UIColor.clear.cgColor
            light_set_4_button.layer.borderWidth = 0
            light_set_4_button.layer.cornerRadius = 0
        case 4:
            light_set_0_button.layer.borderColor = UIColor.clear.cgColor
            light_set_0_button.layer.borderWidth = 0
            light_set_0_button.layer.cornerRadius = 0
            light_set_1_button.layer.borderColor = UIColor.clear.cgColor
            light_set_1_button.layer.borderWidth = 0
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.clear.cgColor
            light_set_2_button.layer.borderWidth = 0
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.clear.cgColor
            light_set_3_button.layer.borderWidth = 0
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.black.cgColor
            light_set_4_button.layer.borderWidth = 4
            light_set_4_button.layer.cornerRadius = 8
        default:
            light_set_0_button.layer.borderColor = UIColor.black.cgColor
            light_set_0_button.layer.borderWidth = 4
            light_set_0_button.layer.cornerRadius = 8
            light_set_1_button.layer.borderColor = UIColor.clear.cgColor
            light_set_1_button.layer.borderWidth = 0
            light_set_1_button.layer.cornerRadius = 0
            light_set_2_button.layer.borderColor = UIColor.clear.cgColor
            light_set_2_button.layer.borderWidth = 0
            light_set_2_button.layer.cornerRadius = 0
            light_set_3_button.layer.borderColor = UIColor.clear.cgColor
            light_set_3_button.layer.borderWidth = 0
            light_set_3_button.layer.cornerRadius = 0
            light_set_4_button.layer.borderColor = UIColor.clear.cgColor
            light_set_4_button.layer.borderWidth = 0
            light_set_4_button.layer.cornerRadius = 0
       }
        dark_set_0_button.backgroundColor = UIColor(named: "0_dark_navBarTintColor")
        dark_set_0_button.layer.borderColor = UIColor.lightGray.cgColor
        dark_set_0_button.layer.borderWidth = 4
        dark_set_0_button.layer.cornerRadius = 8

    }
}
