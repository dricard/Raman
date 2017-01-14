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
    
    var shouldPopVC = true
        
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
            previousValueLabel.text = value.format(".4")
        } else {
            print("ERROR in ChangeValueViewController viewDidLoad: trying to unwrap nil value in viewDidLoad of ChangeValueVC: selectedValue")
        }
        
        if let index = selectedDataSource {
            switch whichTab! {
            case Raman.DataSourceType.spectroscopy:
                dataSourceLabel.text = Constants.ramanShift[index]
            case Raman.DataSourceType.bandwidth:
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

    override func viewWillDisappear(_ animated: Bool) {
        shouldPopVC = false

    }
    
    // MARK: - User Actions
    
    @IBAction func cancelChangeValue(_ sender: AnyObject) {
        self.newValue.resignFirstResponder()
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Utilities functions
    
    // Enable touch outside textField to end editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkForValidValue(_ toTest: Double) -> Bool {
        
        let error = ramanData.spectro.checkForValidData(toTest, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
        if error.valid {
            return true
        } else {
            if let message = error.errorMessage {
                let alert = UIAlertController(title: "Invalid entry", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Invalid entry", message: "Value entered is not a valid number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
    }
    
    // MARK: - Textfield delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // check that we can typecast into a Double
        if let theReturnValue = Double(textField.text!) {
            // then check that the value entered is valid for that variable
            if checkForValidValue(theReturnValue) {
                newValue.text = "\(theReturnValue)"
                valueChanged = true
                ramanData.spectro.updateParameter(theReturnValue, forDataSource: selectedDataSource!, inWhichTab: whichTab!)
           } else {
                newValue.text = "\(selectedValue!)"
                valueChanged = false
            }
        } else {
            print("ERR: return value from UITextField not valid in ChangeValueViewController / textFieldShouldReturn")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        if shouldPopVC {
            self.navigationController!.popViewController(animated: true)
        }
    }

}
