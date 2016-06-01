//
//  ChangeValueViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ChangeValueViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    // local reference to model data
    let ramanData = Model.sharedInstance
    
    // These parameters are passed to this viewController
    var myUnits : String?
    var toolTipString : String?
    var selectedValue : Double?
    var selectedDataSource : Int?   // which value in the list we're changing
    var whichTab: Raman.DataSourceType?
    
//    var selectedSection : Int?
    
    var valueChanged : Bool = false
    var theReturnValue : Double = 0.0
        
    // MARK: - Outlets
    
    @IBOutlet var dataSourceLabel: UILabel!
    
    @IBOutlet var unitsLabel: UILabel!
    
    @IBOutlet var previousValueLabel: UILabel!
    
    @IBOutlet var toolTipLabel: UILabel!
    
    @IBOutlet var newValue: UITextField!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueChanged = false
        
        self.title = "Edit value"
        
        // set the labels with the passed properties
        if let value = selectedValue {
            previousValueLabel.text = "\(value)"
        } else {
            print("ERROR in ChangeValueViewController viewDidLoad: trying to unwrap nil value in viewDidLoad of ChangeValueVC: selectedValue")
        }
        
        if let index = selectedDataSource {
            switch whichTab! {
            case Raman.DataSourceType.Spectroscopy:
                dataSourceLabel.text = Constants.ramanShift[index]
            case Raman.DataSourceType.Bandwidth:
                dataSourceLabel.text = Constants.ramanBandwidth[index]
            }
            
        } else {
            print("ERROR in ChangeValueViewController viewDidLoad: trying to unwrap nil value in viewDidLoad of ChangeValueVC: selectedDataSource")
        }
        
        if let units = myUnits {
            unitsLabel.text = units
        } else {
            print("ERROR in ChangeValueViewController viewDidLoad: trying to unwrap nil value in viewDidLoad of ChangeValueVC: myUnits")
        }
        
        if let toolTip = toolTipString {
            toolTipLabel.text = toolTip
        } else {
            print("ERROR in ChangeValueViewController viewDidLoad: trying to unwrap nil value in viewDidLoad of ChangeValueVC: toolTipString")
        }
        
    }

    
    // MARK: - User Actions
    
    @IBAction func cancelChangeValue(sender: AnyObject) {
//        newValue.text = ""
//        if valueChanged {
//            // do the switch statement
//            if selectedSection! == 0 {
//                switch selectedDataSource! {
//                case 0:
//                    ramanData.spectro.pump = selectedValue!
//                case 1:
//                    ramanData.spectro.signal = selectedValue!
//                case 2:
//                    ramanData.spectro.shiftInCm = selectedValue!
//                case 3:
//                    ramanData.spectro.shiftInGhz = selectedValue!
//                case 4:
//                    ramanData.spectro.shiftInMev = selectedValue!
//                default:
//                    print("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
//                    break
//                }
//            } else {
//                switch selectedDataSource! {
//                case 0:
//                    ramanData.spectro.bwLambda = selectedValue!
//                case 1:
//                    ramanData.spectro.bwInCm = selectedValue!
//                case 2:
//                    ramanData.spectro.bwInGhz = selectedValue!
//                case 3:
//                    ramanData.spectro.bwInNm = selectedValue!
//                default:
//                    print("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
//                }
//            }
//        }
        
       self.newValue.resignFirstResponder()
    }
    
    // MARK: - Utilities functions
    
    // Enable touch outside textField to end editing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkForValidValue(toTest: Double) -> Bool {
        
        let error = ramanData.spectro.checkForValidData(toTest, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
        if error.valid {
            return true
        } else {
            if let message = error.errorMessage {
                let alert = UIAlertController(title: "Invalid entry", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Invalid entry", message: "Value entered is not a valid number", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            return false
        }
    }
    
    // MARK: - Textfield delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        println(newValue.text)
//        println("test: spectro variable is accessible if this gives a value: \(ramanData.spectro.pump)")
//        theReturnValue = newValue.text as! doubleValue
        
        // check that we can typecast into a Double
        if let theReturnValue = Double(textField.text!) {
            // then check that the value entered is valid for that variable
            if checkForValidValue(theReturnValue) {
    //            println("return value (\(theReturnValue)) is valid")
                newValue.text = "\(theReturnValue)"
                valueChanged = true
                ramanData.spectro.updateParameter(theReturnValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
           } else {
                newValue.text = "\(selectedValue!)"
    //            println("return value is NOT valid")
                valueChanged = false
            }
        } else {
            print("ERR: return value from UITextField not valid in ChangeValueViewController / textFieldShouldReturn")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.navigationController!.popViewControllerAnimated(true)
    }

}
