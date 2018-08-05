//
//  CalculatorViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-17.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit
import os.log

class CalculatorViewController: UIViewController {
    
    enum DigitType {
        case period
        case delete
        case number(Int)
        case error(String)
        
        func digitFrom(_ key: String) -> DigitType {
            switch key {
            case ".":
                return .period
            case "⬅︎":
                return .delete
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                return .number(Int(key)!)
            default:
                return .error("not a defined digit")
            }
        }
    }

    // MARK: - Properties
    
    var Current: Environment?
    
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
    var selectedDataSource : Int?           // which value in the list we're changing
    var whichTab: Raman.DataSourceType?     // which value set we're in (spectro or bandwidth)
    
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
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var parameterTitleLabel: UILabel!
    @IBOutlet weak var unitsTitleLabel: UILabel!
    @IBOutlet weak var previousValueTitleLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func digitPressed(_ sender: UIButton) {
        guard let key = sender.currentTitle else { return }
        
        let digit: DigitType
        switch key {
        case ".":
            digit = .period
        case "⬅︎":
            digit = .delete
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            digit = .number(Int(key)!)
        default:
            digit = .error("not a defined digit")
        }
        enterDigit(digit)
    }
    
    
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
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
            guard let Current = Current else { return }
            Current.raman.updateParameter(currentValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
            
            switch recentsTrack(forDataSource: selectedDataSource!, inWhichTab: whichTab!) {
            case .excitations:
                Current.excitations.push(currentValue, with: .wavelength)
                os_log("Pushed value %.4f to excitations recents", log: Log.general, type: .debug, currentValue)
            case .signals:
                Current.signals.push(currentValue, with: .wavelength)
                os_log("Pushed value %.4f to signals recents", log: Log.general, type: .debug, currentValue)
            case .bandwidths:
                let type = typeForBandwidth(of: selectedDataSource!)
                Current.bandwidths.push(currentValue, with: type)
                os_log("Pushed value %.4f to bandwidths recents", log: Log.general, type: .debug, currentValue)
            case .shifts:
                let type = typeForShift(of: selectedDataSource!)
                Current.shifts.push(currentValue, with: type)
                // if we changed the shift value, the signal value was also updated so we need to
                // also push it on the signals' stack
                Current.signals.push(Current.raman.signal, with: .wavelength)
                os_log("Pushed value %.4f to shifts recents", log: Log.general, type: .debug, currentValue)
                os_log("Pushed value %.4f to signals recents", log: Log.general, type: .debug, Current.raman.signal)
            }
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
        
        // add cancel button and localize
        let cancelButton = UIBarButtonItem(title: .cancelButton, style: .plain, target: self, action: #selector(CalculatorViewController.cancelEntry))
        navigationItem.rightBarButtonItem = cancelButton
        
        // set the labels with the passed properties
        if let value = selectedValue {
            previousValueLabel.text = value.format(".4")
        } else {
            os_log("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad", log: Log.general, type: .error)
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
            os_log("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad", log: Log.general, type: .error)
        }
        
        if let units = myUnits, let myExp = myExp {
            unitsLabel.text = units
            exponentLabel.text = myExp
        } else {
            os_log("ERROR in CalculatorViewController viewDidLoad: trying to unwrap nil value in viewDidLoad", log: Log.general, type: .error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Data entry
    
    func enterDigit(_ digitPressed: DigitType) {
        switch digitPressed {
        case .period:
            if singlePeriod {
                return
            } else {
                singlePeriod = true
                if enteringData {
                    displayLabel.text = displayLabel.text! + "."
                } else {
                    displayLabel.text = "."
                    enteringData = true
                }
                return
            }
        case .delete:
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
        case .number(let digit):
            if enteringData {
                displayLabel.text = displayLabel.text! + String(digit)
            } else {
                displayLabel.text = String(digit)
                enteringData = true
            }
        case .error(let error):
            print(error)
        }
    }
    
    // MARK: - Utilities
    
    enum Track {
        case excitations
        case signals
        case bandwidths
        case shifts
    }
    
    func recentsTrack(forDataSource: Int, inWhichTab: Raman.DataSourceType) -> Track {
        switch inWhichTab {
        case .spectroscopy:
            switch forDataSource {
            case 0:
                return .excitations
            case 1:
                return .signals
            default:
                return .shifts
            }
        case .bandwidth:
            switch forDataSource {
            case 0:
                return .signals
            default:
                return .bandwidths
            }
        }
    }
    
    func typeForBandwidth(of dataSource: Int) -> RecentType {
        switch dataSource {
        case 1:
            return RecentType.bandwidthInCm
        case 2:
            return RecentType.bandwidthInGhz
        case 3:
            return RecentType.bandwidthInNm
        default:
            os_log("Wrong dataSource value (%d) in 'typeForBandwidth'", log: Log.general, type: .error, dataSource)
            return RecentType.bandwidthInCm
        }
    }
    
    func typeForShift(of dataSource: Int) -> RecentType {
        switch dataSource {
        case 2:
            return RecentType.shiftInCm
        case 3:
            return RecentType.shiftInGhz
        case 4:
            return RecentType.shiftInMev
        default:
            os_log("Wrong dataSource value (%d) in 'typeForShift'", log: Log.general, type: .error, dataSource)
            return RecentType.shiftInCm
        }
    }
    
    func fontSizeClasses() -> [CGFloat] {
        switch view.frame.width {
        case 0...320:
            let fontSizes: [CGFloat] = [12, 16, 13, 25, 40, 96]
            return fontSizes
        case 321...375:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40, 96]
            return fontSizes
        case 376...414:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40, 96]
            return fontSizes
        case 415...768:
            let fontSizes: [CGFloat] = [25, 24, 32, 40, 72, 96]
            return fontSizes
        case 1024...:
            let fontSizes: [CGFloat] = [25, 32, 40, 50, 96, 120]
            return fontSizes
        default:
            let fontSizes: [CGFloat] = [12, 16, 19, 25, 40, 60]
            return fontSizes
        }
    }
    
    func updateInterface() {
        if let Current = Current {
            
            let fontSizes = fontSizeClasses()
            
            displayLabel.font = UIFont.boldSystemFont(ofSize: fontSizes[5])
            previousValueLabel.font = UIFont.systemFont(ofSize: fontSizes[2])
            parameterLabel.font = UIFont.systemFont(ofSize: fontSizes[2])
            unitsLabel.font = UIFont.systemFont(ofSize: fontSizes[3])
            exponentLabel.font = UIFont.systemFont(ofSize: fontSizes[0])
            previousValueTitleLabel.font = UIFont.italicSystemFont(ofSize: fontSizes[1])
            parameterTitleLabel.font = UIFont.italicSystemFont(ofSize: fontSizes[1])
            unitsTitleLabel.font = UIFont.italicSystemFont(ofSize: fontSizes[1])
            
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")!]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            self.tabBarController?.tabBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            
            let buttonsColors = UIColor(named: "\(Current.colorSet.prefix())displayBackgroundColor")
            let displayColor = UIColor(named: "\(Current.colorSet.prefix())displayBackgroundColor")
            let displayTextColor = UIColor(named: "\(Current.colorSet.prefix())displayTextColor")
            let displayTitleColor = displayTextColor?.withAlphaComponent(0.7)
            
            // set display
            displayView.backgroundColor = displayColor
            parameterLabel.textColor = displayTextColor
            previousValueLabel.textColor = displayTextColor
            displayLabel.textColor = displayTextColor
            unitsLabel.textColor = displayTextColor
            exponentLabel.textColor = displayTextColor
            parameterTitleLabel.textColor = displayTitleColor
            unitsTitleLabel.textColor = displayTitleColor
            previousValueTitleLabel.textColor = displayTitleColor
            
            // set buttons
            digitButton0.backgroundColor = buttonsColors
            digitButton0.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton0.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton9.backgroundColor = buttonsColors
            digitButton9.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton9.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton8.backgroundColor = buttonsColors
            digitButton8.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton8.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton7.backgroundColor = buttonsColors
            digitButton7.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton7.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton6.backgroundColor = buttonsColors
            digitButton6.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton6.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton5.backgroundColor = buttonsColors
            digitButton5.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton5.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton4.backgroundColor = buttonsColors
            digitButton4.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton4.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton3.backgroundColor = buttonsColors
            digitButton3.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton3.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton2.backgroundColor = buttonsColors
            digitButton2.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton2.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton1.backgroundColor = buttonsColors
            digitButton1.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButton1.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButtonPeriod.backgroundColor = buttonsColors
            digitButtonPeriod.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButtonPeriod.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButtonBackspace.backgroundColor = buttonsColors
            digitButtonBackspace.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            digitButtonBackspace.titleLabel?.font = UIFont.systemFont(ofSize: fontSizes[4])
            operationButtonEqual.backgroundColor = buttonsColors
            operationButtonEqual.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            operationButtonEqual.titleLabel?.font = UIFont.systemFont(ofSize: fontSizes[4])
            operationButtonPlus.backgroundColor = buttonsColors
            operationButtonPlus.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            operationButtonPlus.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            operationButtonMinus.backgroundColor = buttonsColors
            operationButtonMinus.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            operationButtonMinus.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            tooltipButton.backgroundColor = buttonsColors
            tooltipButton.tintColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
            tooltipButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSizes[4])
        }
    }
    
}

extension CalculatorViewController: UIPopoverPresentationControllerDelegate {
    
    fileprivate func displayMemoriesTableViewSize() -> CGSize {
        return CGSize(width: 150, height: 408)
    }
    
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
