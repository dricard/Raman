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
    
    
    @IBOutlet weak var digitButtonBackspace: UIButton!
    @IBOutlet weak var digitButtonPeriod: UIButton!
    @IBOutlet weak var digitButton0: UIButton!
    @IBOutlet weak var digitButton1: UIButton!
    @IBOutlet weak var digitButton2: UIButton!
    @IBOutlet weak var digitButton3: UIButton!
    @IBOutlet weak var digitButton4: UIButton!
    @IBOutlet weak var digitButton5: UIButton!
    @IBOutlet weak var digitButton6: UIButton!
    @IBOutlet weak var digitButton9: UIButton!
    @IBOutlet weak var digitButton8: UIButton!
    @IBOutlet weak var digitButton7: UIButton!
    
    @IBOutlet weak var memoryButtonShow: UIButton!
    @IBOutlet weak var memoryButtonAdd: UIButton!
    @IBOutlet weak var memoryButtonRecall: UIButton!
    @IBOutlet weak var memoryButtonClear: UIButton!
    @IBOutlet weak var operationButtonEqual: UIButton!
    @IBOutlet weak var operationButtonMinus: UIButton!
    @IBOutlet weak var operationButtonPlus: UIButton!
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
        if digit == "⬅︎" {
            let removed = displayLabel.text?.last
            // reset singlePeriod if we deleted one
            if removed == "." {
                singlePeriod = false
            }
            let text = String(displayLabel.text!.dropLast())
            // reset state if we deleted last digit
            if text == "" {
                enteringData = false
                displayLabel.text = "0"
                return
            } else {
                displayLabel.text = text
                return
            }
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
        if sender.currentTitle == "⏎" {
            guard let raman = raman else { return }
            raman.updateParameter(currentValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
            self.navigationController!.popViewController(animated: true)
            
        }
    }
    
    @IBAction func tooltipButtonPressed(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TooltipPopoverViewController") as? TooltipPopoverViewController, let tooltip = toolTipString {
            vc.modalPresentationStyle = .popover
            vc.tooltipText = tooltip
            let controller = vc.popoverPresentationController!
            controller.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func cancelEntry() {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial state of display
        displayLabel.text = "0"
        
        // apply theme
        // set navigation bar
        
        updateInterface()
        
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

    // MARK: - Utilities
    
    func updateInterface() {
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
            
            let buttonsColors = Theme.color(for: .tableViewBackgroundColor, with: selectedTheme.mode)
            let displayColor = Theme.color(for: .displayBackgroundColor, with: selectedTheme.mode)
            let displayTextColor = Theme.color(for: .displayTextColor, with: selectedTheme.mode)
            
            // set display
            displayView.backgroundColor = displayColor
            parameterLabel.textColor = displayTextColor
            previousValueLabel.textColor = displayTextColor
            displayLabel.textColor = displayTextColor
            unitsLabel.textColor = displayTextColor
            exponentLabel.textColor = displayTextColor
            
            // set buttons
            digitButton0.backgroundColor = buttonsColors
            digitButton0.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton9.backgroundColor = buttonsColors
            digitButton9.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton8.backgroundColor = buttonsColors
            digitButton8.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton7.backgroundColor = buttonsColors
            digitButton7.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton6.backgroundColor = buttonsColors
            digitButton6.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton5.backgroundColor = buttonsColors
            digitButton5.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton4.backgroundColor = buttonsColors
            digitButton4.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton3.backgroundColor = buttonsColors
            digitButton3.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton2.backgroundColor = buttonsColors
            digitButton2.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButton1.backgroundColor = buttonsColors
            digitButton1.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButtonPeriod.backgroundColor = buttonsColors
            digitButtonPeriod.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            digitButtonBackspace.backgroundColor = buttonsColors
            digitButtonBackspace.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            memoryButtonShow.backgroundColor = buttonsColors
            memoryButtonShow.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            memoryButtonClear.backgroundColor = buttonsColors
            memoryButtonClear.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            memoryButtonRecall.backgroundColor = buttonsColors
            memoryButtonRecall.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            memoryButtonAdd.backgroundColor = buttonsColors
            memoryButtonAdd.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            operationButtonEqual.backgroundColor = buttonsColors
            operationButtonEqual.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            operationButtonPlus.backgroundColor = buttonsColors
            operationButtonPlus.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            operationButtonMinus.backgroundColor = buttonsColors
            operationButtonMinus.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
            tooltipButton.backgroundColor = buttonsColors
            tooltipButton.tintColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        }
    }
    
}

extension CalculatorViewController: UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        let presentationController: UIPopoverPresentationController = popoverPresentationController.presentedViewController.popoverPresentationController!
        popoverPresentationController.presentedViewController.preferredContentSize = CGSize(width: 275, height: 125)
        
         presentationController.permittedArrowDirections = UIPopoverArrowDirection.down
        presentationController.sourceView = tooltipButton
        presentationController.sourceRect = tooltipButton.bounds
    }
    
    // This is required to make the popover show on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
