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
    
    enum Mode {
        case dataEntry
        case memoryOperation(MemoryOperation)
    }
    
    typealias MemorySlotsRange = Int
    
    enum MemoryOperation {
        case store(Double)
        case recall
    }

    // MARK: - Properties
    
    var Current: Environment?

//    var raman: Raman?
//    var selectedTheme: ThemeMode?
//    var memory: Memory?
    var mode: Mode = .dataEntry
    
    private var calculator = Calculator()
    private var singlePeriod = false
    private var enteringData = false
    private var memoryOperationInProcess = false
    
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
    @IBOutlet weak var buyMemoriesView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var memoryAdTextLabel: UILabel!
    @IBOutlet weak var memoryAdTitleLabel: UILabel!
    @IBOutlet weak var memoryImageView: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func digitPressed(_ sender: UIButton) {
        guard let key = sender.currentTitle else { return }
        switch mode {
        case .dataEntry:
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
        case .memoryOperation(let operation):
            // only accept digits 0-9 for memory operations (store or recall)
            guard "0123456789".contains(key), let Current = Current, let dataSource = whichTab, let parameter = selectedDataSource, let memorySlot = Int(key) else { return }
            switch operation {
            case .recall:
                let value = Current.memory.retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot)
                Current.memory.currentSelection[dataSource]![parameter]! = memorySlot
                displayLabel.text = "\(value)"
            case .store(let value):
                displayLabel.text = "\(value)"
                Current.memory.addTo(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot, value: value)
                Current.memory.currentSelection[dataSource]![parameter]! = memorySlot
                Current.memory.saveMemoryToDisk()
            }
            mode = .dataEntry
            memoryOperationInProcess = false
        }
    }
    
    @IBAction func memoryButtonPressed(_ sender: UIButton) {
        guard let key = sender.currentTitle else { return }
        switch key {
        case "M+":
            if !memoryOperationInProcess {
                guard let value = Double(displayLabel.text!) else { return }
                displayLabel.text = "select 0-9"
                mode = .memoryOperation(.store(value))
                memoryOperationInProcess = true
            }
        case "Mr":
            if !memoryOperationInProcess {
                displayLabel.text = "select 0-9"
                mode = .memoryOperation(.recall)
                memoryOperationInProcess = true
            }
        case "Ms":
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowMemoryViewController") as? ShowMemoryViewController, let Current = Current, let dataSource = whichTab, let parameter = selectedDataSource {
                vc.modalPresentationStyle = .popover
                vc.mems = Current.memory.memoryArray(dataSource: dataSource, parameter: parameter)
                vc.delegate = self
                let stringFormat: String
                if let whichTab = whichTab, let selectedDataSource = selectedDataSource {
                    switch whichTab {
                    case .spectroscopy:
                        stringFormat = Constants.specRounding[selectedDataSource]
                    case .bandwidth:
                        stringFormat = Constants.bwRounding[selectedDataSource]
                    }
                } else {
                   stringFormat = ".2"
                }
                vc.formatString = stringFormat
                let controller = vc.popoverPresentationController!
                controller.delegate = self
                present(vc, animated: true, completion: nil)
            }
        case "Mc":
            if !memoryOperationInProcess {
                let controller = UIAlertController()
                controller.title = "Clear all?"
                controller.message = "Are you sure you want to delete all stored values?\nThis will delete all values for the current parameter."
                let clearAllAction = UIAlertAction(title: "Yes, delete all", style: .destructive) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    guard let Current = self.Current, let dataSource = self.whichTab, let parameter = self.selectedDataSource else { return }
                    Current.memory.clearMemoryFor(dataSource: dataSource, parameter: parameter)
                }
                controller.addAction(clearAllAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                controller.addAction(cancelAction)
                present(controller, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        if !memoryOperationInProcess {
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
                guard let Current = Current else { return }
                Current.raman.updateParameter(currentValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
                
                switch recentsTrack(forDataSource: selectedDataSource!, inWhichTab: whichTab!) {
                case .excitations:
                    Current.excitations.push(currentValue, with: .wavelength)
                    Current.excitations.save(with: "excitations")
                    os_log("Pushed value %.4f to excitations recents", log: Log.general, type: .debug, currentValue)
                case .signals:
                    Current.signals.push(currentValue, with: .wavelength)
                    Current.signals.save(with: "signals")
                    os_log("Pushed value %.4f to signals recents", log: Log.general, type: .debug, currentValue)
                case .bandwidths:
                    let type = typeForBandwidth(of: selectedDataSource!)
                    Current.bandwidths.push(currentValue, with: type)
                    Current.bandwidths.save(with: "bandwidths")
                    os_log("Pushed value %.4f to bandwidths recents", log: Log.general, type: .debug, currentValue)
                case .shifts:
                    let type = typeForShift(of: selectedDataSource!)
                    Current.shifts.push(currentValue, with: type)
                    Current.shifts.save(with: "shifts")
                    // if we changed the shift value, the signal value was also updated so we need to
                    // also push it on the signals' stack
                    Current.signals.push(Current.raman.signal, with: .wavelength)
                    Current.signals.save(with: "signals")
                    os_log("Pushed value %.4f to shifts recents", log: Log.general, type: .debug, currentValue)
                    os_log("Pushed value %.4f to signals recents", log: Log.general, type: .debug, Current.raman.signal)
                }
                self.navigationController!.popViewController(animated: true)
            }
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
    
    
    // MARK: - Data entry and memory management
    
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
            let fontSizes: [CGFloat] = [12, 16, 13, 25, 40]
            return fontSizes
        case 321...375:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40]
            return fontSizes
        case 376...414:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40]
            return fontSizes
        case 415...768:
            let fontSizes: [CGFloat] = [25, 24, 32, 40, 72]
            return fontSizes
        case 1024...:
            let fontSizes: [CGFloat] = [25, 32, 40, 50, 96]
            return fontSizes
        default:
            let fontSizes: [CGFloat] = [12, 16, 19, 25, 40]
            return fontSizes
        }
    }
    
    func updateInterface() {
        if let Current = Current {
            
            let fontSizes = fontSizeClasses()
            
            displayLabel.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            previousValueLabel.font = UIFont.systemFont(ofSize: fontSizes[2])
            parameterLabel.font = UIFont.systemFont(ofSize: fontSizes[2])
            unitsLabel.font = UIFont.systemFont(ofSize: fontSizes[3])
            exponentLabel.font = UIFont.systemFont(ofSize: fontSizes[0])
            
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor")
            self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")!]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor")
            self.tabBarController?.tabBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            
            let buttonsColors = UIColor(named: "\(Current.selectedTheme.prefix())tableViewBackgroundColor")
            let displayColor = UIColor(named: "\(Current.selectedTheme.prefix())displayBackgroundColor")
            let displayTextColor = UIColor(named: "\(Current.selectedTheme.prefix())displayTextColor")
            
            // set display
            displayView.backgroundColor = displayColor
            parameterLabel.textColor = displayTextColor
            previousValueLabel.textColor = displayTextColor
            displayLabel.textColor = displayTextColor
            unitsLabel.textColor = displayTextColor
            exponentLabel.textColor = displayTextColor
            
            // set buttons
            digitButton0.backgroundColor = buttonsColors
            digitButton0.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton0.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton9.backgroundColor = buttonsColors
            digitButton9.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton9.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton8.backgroundColor = buttonsColors
            digitButton8.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton8.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton7.backgroundColor = buttonsColors
            digitButton7.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton7.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton6.backgroundColor = buttonsColors
            digitButton6.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton6.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton5.backgroundColor = buttonsColors
            digitButton5.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton5.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton4.backgroundColor = buttonsColors
            digitButton4.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton4.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton3.backgroundColor = buttonsColors
            digitButton3.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton3.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton2.backgroundColor = buttonsColors
            digitButton2.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton2.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButton1.backgroundColor = buttonsColors
            digitButton1.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButton1.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButtonPeriod.backgroundColor = buttonsColors
            digitButtonPeriod.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButtonPeriod.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            digitButtonBackspace.backgroundColor = buttonsColors
            digitButtonBackspace.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            digitButtonBackspace.titleLabel?.font = UIFont.systemFont(ofSize: fontSizes[4])
            memoryButtonShow.backgroundColor = buttonsColors
            memoryButtonShow.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            memoryButtonShow.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            memoryButtonClear.backgroundColor = buttonsColors
            memoryButtonClear.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            memoryButtonClear.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            memoryButtonRecall.backgroundColor = buttonsColors
            memoryButtonRecall.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            memoryButtonRecall.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            memoryButtonAdd.backgroundColor = buttonsColors
            memoryButtonAdd.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            memoryButtonAdd.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            operationButtonEqual.backgroundColor = buttonsColors
            operationButtonEqual.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            operationButtonEqual.titleLabel?.font = UIFont.systemFont(ofSize: fontSizes[4])
            operationButtonPlus.backgroundColor = buttonsColors
            operationButtonPlus.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            operationButtonPlus.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            operationButtonMinus.backgroundColor = buttonsColors
            operationButtonMinus.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
            operationButtonMinus.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSizes[4])
            tooltipButton.backgroundColor = buttonsColors
            tooltipButton.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
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
        if popoverPresentationController.presentedViewController.title == "Memories" {
            // This is the popover that displays the memory content in a tableview
            popoverPresentationController.presentedViewController.preferredContentSize = displayMemoriesTableViewSize()
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.right
            presentationController.sourceView = memoryButtonShow
            presentationController.sourceRect = memoryButtonShow.bounds

        } else {
            popoverPresentationController.presentedViewController.preferredContentSize = CGSize(width: 275, height: 125)
            
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.down
            presentationController.sourceView = tooltipButton
            presentationController.sourceRect = tooltipButton.bounds
        }
    }
    
    // This is required to make the popover show on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension CalculatorViewController: CallMemoryDelegate {
    
    func returnedValueIs(newValue: Double, newIndex: Int) {
        
        guard let Current = Current, let dataSource = whichTab, let parameter = selectedDataSource else { return }
        Current.raman.updateParameter(newValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
        Current.memory.currentSelection[dataSource]![parameter]! = newIndex
        self.navigationController!.popViewController(animated: true)

    }
}
