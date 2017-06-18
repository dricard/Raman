//
//  CalculatorViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-17.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    var raman: Raman?
    var selectedTheme: ThemeMode?

    private var calculator = Calculator()
    private var singlePeriod = false
    private var enteringData = false
    
    var currentValue: Double {
        get {
            if let value = Double(displayLabel.text!) {
                return value
            } else {
                return 0
            }
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    // These parameters are passed to this viewController
    @objc var myUnits : String?
    @objc var myExp: String?
    @objc var toolTipString : String?
    var selectedValue : Double?
    var selectedDataSource : Int?   // which value in the list we're changing
    var whichTab: Raman.DataSourceType?

    // MARK: - Outlets
    
    @IBOutlet weak var digitButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var tooltipButton: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var previousValueLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var exponentLabel: UILabel!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var memoriesView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    
    // MARK: - Actions
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if singlePeriod {
                return
            } else {
                singlePeriod = true
            }
        }
        if digit == "d" {
            let removed = displayLabel.text?.last
            if removed == "." {
                singlePeriod = false
            }
            let text = String(displayLabel.text!.dropLast())
            displayLabel.text = text
            return
        }
        if enteringData {
            displayLabel.text = displayLabel.text! + digit
        } else {
            displayLabel.text = digit
            enteringData = true
        }
    }
    
    @IBAction func memoryButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        // enable entering negative numbers by pressing
        // the '-' as the very first thing
        if !enteringData && currentValue == 0 && sender.currentTitle == "-" {
            displayLabel.text = "-"
            enteringData = true
        } else {
            enteringData = false
            singlePeriod = false
            if let value = calculator.performOperation(key: sender.currentTitle!, operand: currentValue) {
                currentValue = value
            }
        }
        if sender.currentTitle == "=" {
            guard let raman = raman else { return }
            raman.updateParameter(currentValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
            self.navigationController!.popViewController(animated: true)
            
        }
    }
    
    @IBAction func tooltipButtonPressed(_ sender: UIButton) {
    }
    
    @objc func cancelEntry() {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial state of display
        displayLabel.text = "0"
        
        // apply theme
        // set navigation bar
        if let selectedTheme = selectedTheme {
            
            self.navigationController?.navigationBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Theme.color(for: .navBarTextColor, with: selectedTheme.mode)]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
            self.tabBarController?.tabBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            if #available(iOS 10.0, *) {
                self.tabBarController?.tabBar.unselectedItemTintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            } else {
                // Fallback on earlier versions
            }
            
            // set display
            displayView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: selectedTheme.mode)
        }
        
        // localization
        self.title = .editValueLabel
        
        // TODO: - add cancel button and localize
        let cancelButton = UIBarButtonItem(title: .cancelButton, style: .plain, target: self, action: #selector(CalculatorViewController.cancelEntry))
        navigationItem.rightBarButtonItem = cancelButton
        
        // set the labels with the passed properties
        if let value = selectedValue {
            previousValueLabel.text = value.format(".4")
        } else {
            print("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad")
        }
        
        // set parameter being modified
        if let index = selectedDataSource {
            switch whichTab! {
            case Raman.DataSourceType.spectroscopy:
                parameterLabel.text = Constants.ramanShift[index]
            case Raman.DataSourceType.bandwidth:
                parameterLabel.text = Constants.ramanBandwidth[index]
            }
            
        } else {
            print("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad")
        }
        
        if let units = myUnits, let myExp = myExp {
            unitsLabel.text = units
            exponentLabel.text = myExp
        } else {
            print("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad")
        }
        
        
    }


}
