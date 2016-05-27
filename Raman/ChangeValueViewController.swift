//
//  ChangeValueViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ChangeValueViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    let excitation = 0
    let signal = 1
    let shiftNm = 2
    let shiftGhz = 3
    let shiftMev = 4
    
    let laser = 0
    let bwNm = 1
    let bwGhz = 2
    let bwMev = 3
    
    let ramanData = Model.sharedInstance
//    
//    let ramanShift = ["Excitation wavelenth", "Signal wavelength", "Raman shift", "Raman shift", "Raman shift"]
//    
//    let ramanBandwidth = ["Wavelength", "Bandwidth", "Bandwidth", "Bandwidth"]
//
//    let myUnits = ["nm", "nm", "cm-1", "GHz", "MeV", "nm", "cm-1", "GHz", "nm"]
    
    var myUnits : String?
    
    var toolTipString : String?
    
    var selectedValue : Double?
    
    var selectedDataSource : Int?
    
//    var selectedSection : Int?
    
    var valueChanged : Bool = false
    
    var theReturnValue : Double = 0.0
        
    // MARK: Outlets
    
    @IBOutlet var dataSourceLabel: UILabel!
    
    @IBOutlet var unitsLabel: UILabel!
    
    @IBOutlet var previousValueLabel: UILabel!
    
    @IBOutlet var toolTipLabel: UILabel!
    
    @IBOutlet var newValue: UITextField!
    
    // MARK: User Actions
    
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
    
    // MARK: Utilities functions
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkForValidValue(toTest: Double) -> Bool {
//        if toTest == 0 {
//            let alert = UIAlertController(title: "Invalid entry", message: "Value entered is not a valid number", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            return false
//        } else {
//            if selectedSection! == 0 {
//                switch selectedDataSource! {
//                case 0:
//                    if toTest > 0 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 1:
//                    if toTest > 0 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 2:
//                    if toTest > -100000 && toTest < 100000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 100000cm-1", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 3:
//                    if toTest > -90000000 && toTest < 90000000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 90000000GHz", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 4:
//                    if toTest > -10000 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000meV", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                default:
//                    print("ERROR in checkForValidValue of selectedDataSource - bad return value")
//                    break
//                }
//            } else {
//                switch selectedDataSource! {
//                case 0:
//                    if toTest > 0 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 1:
//                    if toTest > -10000 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000cm-1", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 2:
//                    if toTest > -90000000 && toTest < 90000000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 90000000GHz", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                case 3:
//                    if toTest > -10000 && toTest < 10000 {
//                        return true
//                    } else {
//                        let alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000meV", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//                default:
//                    print("ERROR in checkForValidValue of ChangeValueViewController - bad selectedDataSource value")
//                }
//            }
            return true

//        }
    }
    
    // MARK Textfield delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        println(newValue.text)
//        println("test: spectro variable is accessible if this gives a value: \(ramanData.spectro.pump)")
//        theReturnValue = newValue.text as! doubleValue
        
        if let theReturnValue = Double(textField.text!) {
            if checkForValidValue(theReturnValue) {
    //            println("return value (\(theReturnValue)) is valid")
                newValue.text = "\(theReturnValue)"
                valueChanged = true
            } else {
                newValue.text = "\(selectedValue!)"
    //            println("return value is NOT valid")
                valueChanged = false
            }
        } else {
            print("ERR: return value from UITextField not valid in ChangeValueViewController / textFieldShouldReturn")
        }
        
//        if valueChanged {
            // do the switch statement
//            if selectedSection! == 0 {
//                switch selectedDataSource! {
//                case 0:
//                    ramanData.spectro.pump = theReturnValue
//                case 1:
//                    ramanData.spectro.signal = theReturnValue
//                case 2:
//                    ramanData.spectro.shiftInCm = theReturnValue
//                case 3:
//                    ramanData.spectro.shiftInGhz = theReturnValue
//                case 4:
//                    ramanData.spectro.shiftInMev = theReturnValue
//                default:
//                    print("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
//                    break
//                }
//            } else {
//                switch selectedDataSource! {
//                case 0:
//                    ramanData.spectro.bwLambda = theReturnValue
//                case 1:
//                    ramanData.spectro.bwInCm = theReturnValue
//                case 2:
//                    ramanData.spectro.bwInGhz = theReturnValue
//                case 3:
//                    ramanData.spectro.bwInNm = theReturnValue
//                default:
//                    print("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
//                }
//            }
//        }
        
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        valueChanged = false
        
        self.title = "Edit value"
        
        if let value = selectedValue {
            previousValueLabel.text = "\(value)"
        } else {
            print("ERROR: trying to unwrap nil value in viewDidLoad of ChangeValueVC: selectedValue")
        }
        
        if let index = selectedDataSource {
            dataSourceLabel.text = Constants.ramanShift[index]
        } else {
            print("ERROR: trying to unwrap nil value in viewDidLoad of ChangeValueVC: selectedDataSource")
        }

        
        if let units = myUnits {
            unitsLabel.text = units
        } else {
            print("ERROR: trying to unwrap nil value in viewDidLoad of ChangeValueVC: myUnits")
        }

        if let toolTip = toolTipString {
            toolTipLabel.text = toolTip
        } else {
            print("ERROR: trying to unwrap nil value in viewDidLoad of ChangeValueVC: toolTipString")
        }
        
    }

}
