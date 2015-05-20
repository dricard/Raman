//
//  ChangeValueViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ChangeValueViewController: UIViewController, UITextFieldDelegate {

    let excitation = 0
    let signal = 1
    let shiftNm = 2
    let shiftGhz = 3
    let shiftMev = 4
    
    let laser = 0
    let bwNm = 1
    let bwGhz = 2
    let bwMev = 3
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    let ramanShift = ["Excitation wavelenth", "Signal wavelength", "Raman shift", "Raman shift", "Raman shift"]
    
    let ramanBandwidth = ["Wavelength", "Bandwidth", "Bandwidth", "Bandwidth"]

    let myUnits = ["nm", "nm", "cm-1", "GHz", "MeV", "nm", "cm-1", "GHz", "nm"]
    
    var selectedValue : Double?
    
    var selectedDataSource : Int?
    
    var selectedSection : Int?
    
    var valueChanged : Bool = false
    
    var theReturnValue : Double = 0.0
    
    @IBOutlet var dataSourceLabel: UILabel!
    
    @IBOutlet var unitsLabel: UILabel!
    
    @IBOutlet var previousValueLabel: UILabel!
    
    @IBOutlet var toolTipLabel: UILabel!
    
    @IBOutlet var newValue: UITextField!
    
    @IBAction func cancelChangeValue(sender: AnyObject) {
        newValue.text = ""
        if valueChanged {
            // do the switch statement
            if selectedSection! == 0 {
                switch selectedDataSource! {
                case 0:
                    appDelegate.spectro.pump = selectedValue!
                case 1:
                    appDelegate.spectro.signal = selectedValue!
                case 2:
                    appDelegate.spectro.shiftInCm = selectedValue!
                case 3:
                    appDelegate.spectro.shiftInGhz = selectedValue!
                case 4:
                    appDelegate.spectro.shiftInMev = selectedValue!
                default:
                    println("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
                    break
                }
            } else {
                switch selectedDataSource! {
                case 0:
                    appDelegate.spectro.bwLambda = selectedValue!
                case 1:
                    appDelegate.spectro.bwInCm = selectedValue!
                case 2:
                    appDelegate.spectro.bwInGhz = selectedValue!
                case 3:
                    appDelegate.spectro.bwInNm = selectedValue!
                default:
                    println("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
                }
            }
        }
        
       self.newValue.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func checkForValidValue(toTest: Double) -> Bool {
        if toTest == 0 {
            var alert = UIAlertController(title: "Invalid entry", message: "Value entered is not a valid number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        } else {
            if selectedSection! == 0 {
                switch selectedDataSource! {
                case 0:
                    if toTest > 0 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 1:
                    if toTest > 0 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 2:
                    if toTest > -100000 && toTest < 100000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 100000cm-1", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 3:
                    if toTest > -90000000 && toTest < 90000000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 90000000GHz", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 4:
                    if toTest > -10000 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000meV", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                default:
                    println("ERROR in checkForValidValue of selectedDataSource - bad return value")
                    break
                }
            } else {
                switch selectedDataSource! {
                case 0:
                    if toTest > 0 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a wavelength between 1nm and 10000nm", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 1:
                    if toTest > -10000 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000cm-1", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 2:
                    if toTest > -90000000 && toTest < 90000000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 90000000GHz", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                case 3:
                    if toTest > -10000 && toTest < 10000 {
                        return true
                    } else {
                        var alert = UIAlertController(title: "Invalid entry", message: "Please enter a shift in the range +/- 10000meV", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                default:
                    println("ERROR in checkForValidValue of ChangeValueViewController - bad selectedDataSource value")
                }
            }
            return true

        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        println(newValue.text)
//        println("test: spectro variable is accessible if this gives a value: \(appDelegate.spectro.pump)")
        theReturnValue = (newValue.text as NSString).doubleValue
        if checkForValidValue(theReturnValue) {
//            println("return value (\(theReturnValue)) is valid")
            newValue.text = "\(theReturnValue)"
            valueChanged = true
        } else {
            newValue.text = "\(selectedValue!)"
//            println("return value is NOT valid")
            valueChanged = false
        }
        if valueChanged {
            // do the switch statement
            if selectedSection! == 0 {
                switch selectedDataSource! {
                case 0:
                    appDelegate.spectro.pump = theReturnValue
                case 1:
                    appDelegate.spectro.signal = theReturnValue
                case 2:
                    appDelegate.spectro.shiftInCm = theReturnValue
                case 3:
                    appDelegate.spectro.shiftInGhz = theReturnValue
                case 4:
                    appDelegate.spectro.shiftInMev = theReturnValue
                default:
                    println("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
                    break
                }
            } else {
                switch selectedDataSource! {
                case 0:
                    appDelegate.spectro.bwLambda = theReturnValue
                case 1:
                    appDelegate.spectro.bwInCm = theReturnValue
                case 2:
                    appDelegate.spectro.bwInGhz = theReturnValue
                case 3:
                    appDelegate.spectro.bwInNm = theReturnValue
                default:
                    println("ERROR in textFieldShouldReturn of ChangeValueViewController - bad return value")
                }
            }
        }
        
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        valueChanged = false
        
        self.title = "Edit value"
        
        previousValueLabel.text = "\(selectedValue!)"
        
        if selectedSection == 0 {
            dataSourceLabel.text = ramanShift[selectedDataSource!]
            unitsLabel.text = myUnits[selectedDataSource!]
            switch selectedDataSource!  {
            case excitation:
                toolTipLabel.text = "Changing the excitation value will modify the signal based on the current Raman shift."
            case signal:
                toolTipLabel.text = "Changing the signal value will modify the Raman shift based on the current excitation."
            case shiftNm, shiftGhz, shiftMev:
                toolTipLabel.text = "Changing the Raman shift value will modify the signal based on the current excitation."
            default:
                toolTipLabel.text = "Please enter a new value"
            }
            
        } else {
            dataSourceLabel.text = ramanBandwidth[selectedDataSource!]
            unitsLabel.text = myUnits[selectedDataSource! + 5]
            if selectedDataSource == 0 {
                toolTipLabel.text = "Changing the excitation wavelength used for bandwidth calculations will modify the Raman bandwidth values."
            } else {
                toolTipLabel.text = "Changing the current Raman bandwidth value will modify the other two units values (using the current selected excitation wavelength)."
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("In prepareForSegue in ChangeValueViewController preparing to return from segue")
        // Get the new view controller using segue.destinationViewController.
        var secondScene = segue.destinationViewController as! ViewController
        // Pass the selected object to the new view controller.
        secondScene.valueDidChangeFromEdit = valueChanged
        if valueChanged {
            secondScene.whichDataValueChanged = selectedDataSource!
            secondScene.whichSectionValueChanged = selectedSection!
            secondScene.newValueForChangedData = theReturnValue
        }
    }
*/

}
