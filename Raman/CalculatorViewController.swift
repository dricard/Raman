//
//  CalculatorViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-17.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit
import StoreKit

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
    
    var raman: Raman?
    var selectedTheme: ThemeMode?
    var memory: Memory?
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
    
    // IAP properties
    var iapHelper: IAPHelper? {
        didSet {
            updateIAPHelper()
        }
    }
    // this will be set when iapHelper is set through the updateIAPHelper function
    private var memoriesProduct: SKProduct?

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
            guard "0123456789".contains(key), let memory = memory, let dataSource = whichTab, let parameter = selectedDataSource, let memorySlot = Int(key) else { return }
            switch operation {
            case .recall:
                let value = memory.retrieveFrom(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot)
                memory.currentSelection[dataSource]![parameter]! = memorySlot
                displayLabel.text = "\(value)"
            case .store(let value):
                displayLabel.text = "\(value)"
                memory.addTo(dataSource: dataSource, parameter: parameter, memorySlot: memorySlot, value: value)
                memory.currentSelection[dataSource]![parameter]! = memorySlot
                memory.saveMemoryToDisk()
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
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowMemoryViewController") as? ShowMemoryViewController, let memory = memory, let dataSource = whichTab, let parameter = selectedDataSource {
                vc.modalPresentationStyle = .popover
                vc.mems = memory.memoryArray(dataSource: dataSource, parameter: parameter)
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
                    guard let memory = self.memory, let dataSource = self.whichTab, let parameter = self.selectedDataSource else { return }
                    memory.clearMemoryFor(dataSource: dataSource, parameter: parameter)
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
                guard let raman = raman else { return }
                raman.updateParameter(currentValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
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
        
        // IAP observer
        NotificationCenter.default.addObserver(self, selector: #selector(CalculatorViewController.handlePurchaseNotification), name: IAPHelper.iAPHelperPurchaseNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // display memories if purchased
        guard let memory = memory else { return }
        self.buyMemoriesView.isHidden = memory.isPurchased
        self.memoriesView.isHidden = !memory.isPurchased
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
    
    func updateInterface() {
//        if let memory = memory {
//            if memory.isPurchased {
//                setMemoriesPurchased(false)
//            }
//        }
        if let selectedTheme = selectedTheme {
            
            self.navigationController?.navigationBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Theme.color(for: .navBarTextColor, with: selectedTheme.mode)]
            
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

// MARK: - IAP handlers
extension CalculatorViewController {
    
    @IBAction func buyMemoriesTapped(sender: AnyObject) {
        // TODO: - remove following line when done debugging animations and purchased state
        // debug: remove following line when done
        setMemoriesPurchased(true)
        memory!.isPurchased = true
        memory!.saveMemoryToDisk()
        // end debug
        guard let memoriesProduct = memoriesProduct else { return }
        iapHelper?.buyProduct(product: memoriesProduct)
    }
    
    @objc func handlePurchaseNotification(notification: NSNotification) {
        if let productID = notification.object as? String, productID == RamanIAPHelper.memories.productId {
            if let memory = memory {
                memory.isPurchased = true
                memory.saveMemoryToDisk()   // save the purchased status to disk
            }
            setMemoriesPurchased(true)
        }
    }
    
    private func setMemoriesPurchased(_ purchased: Bool, animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve
                    , animations: {
                        self.buyMemoriesView.isHidden = purchased

                }, completion: { (finish) in
                    UIView.animate(withDuration: 0.7, delay: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                        self.memoriesView.isHidden = !purchased

                    }, completion: nil)
                })
//                UIView.animate(withDuration: 5.0) {
//                    self.buyMemoriesView.isHidden = purchased
//                }
//                DispatchQueue.main.async {
//                    UIView.animate(withDuration: 5.0) {
//                        self.memoriesView.isHidden = !purchased
//                    }
//                }
            } else {
                self.buyMemoriesView.isHidden = purchased
                self.memoriesView.isHidden = !purchased
            }
        }
    }
    
    private func updateIAPHelper() {
        // pass to children
        
        guard let iapHelper = iapHelper else { return }
        
        iapHelper.requestProducts { (products) in
            self.memoriesProduct = products!.filter{ $0.productIdentifier == RamanIAPHelper.memories.productId }.first
        }
    }
}

extension CalculatorViewController: CallMemoryDelegate {
    
    func returnedValueIs(newValue: Double, newIndex: Int) {
        
        guard let raman = raman, let memory = memory, let dataSource = whichTab, let parameter = selectedDataSource else { return }
        raman.updateParameter(newValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
        memory.currentSelection[dataSource]![parameter]! = newIndex
        self.navigationController!.popViewController(animated: true)

    }
}
