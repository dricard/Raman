//
//  ViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK: Properties
    
    var ramanData = [0.0, 0.0, 0.0, 0.0, 0.0]
    var bwData = [0.0, 0.0, 0.0, 0.0]

    let excitation = 0
    let signal = 1
    let shiftNm = 2
    let shiftGhz = 3
    let shiftMev = 4
    
    let laser = 0
    let bwNm = 1
    let bwGhz = 2
    let bwMev = 3
    
    let modelData = Model.sharedInstance
    
    var valueDidChangeFromEdit = false
    var whichSectionValueChanged : Int = 0
    var whichDataValueChanged : Int = 0
    var newValueForChangedData : Double = 0.0
    
    // MARK: Outlets
    
    @IBOutlet var myTableView: UITableView!
    
    // Mark: Tableview delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        switch indexPath.row {
        case 0 :
            cell.textLabel!.text = "\(modelData.spectro.pump)"
        case 1 :
            cell.textLabel!.text = "\(modelData.spectro.signal)"
        case 2 :
            cell.textLabel!.text = "\(modelData.spectro.shiftInCm)"
        case 3 :
            cell.textLabel!.text = "\(modelData.spectro.shiftInGhz)"
        case 4 :
            cell.textLabel!.text = "\(modelData.spectro.shiftInMev)"
        default :
            break
        }
        cell.detailTextLabel?.text = Constants.ramanShift[indexPath.row]
        cell.imageView?.image = Constants.cellImage[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("TRACE: IN :didSelectRowAtIndexPath:")
        /* Push the movie detail view */
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ChangeValueViewController") as! ChangeValueViewController

        controller.selectedDataSource = indexPath.row
        controller.selectedValue = modelData.spectro.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        print(Constants.specToolTip[indexPath.row])
        navigationController!.pushViewController(controller, animated: true)
    }

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println("into prepareForSegue")
//        if segue.identifier != nil {
//            // println("Segue identifier is \(segue.identifier)")
//            if segue.identifier! == "changeData" {
//                // println("-- we're in the loop!! --")
//                let sencondScene = segue.destinationViewController as! ChangeValueViewController
//                let cell = sender as! UITableViewCell
//                if let myData = cell.detailTextLabel!.text {
//                    // println(myData)
//                    // println(myData[myData.startIndex])
//                    let temp : String = String(myData[myData.startIndex])
//                    if let cellSelected = Int(temp) {
//                        var mySelection = cellSelected
//                        var sectionSelected : Int
//                        if cellSelected > 5 {
//                            mySelection = cellSelected - 6
//                            sectionSelected = 1
//                        } else {
//                            mySelection = cellSelected - 1
//                            sectionSelected = 0
//                        }
//                        sencondScene.selectedDataSource = mySelection  // represents the index of the value in the values array
//                        
//                        sencondScene.selectedSection = sectionSelected // which data set are we working on here? either raman or
//                        
//                        if sectionSelected == 0 {
//                            switch mySelection {
//                            case 0:
//                                sencondScene.selectedValue = modelData.spectro.pump
//                            case 1:
//                                sencondScene.selectedValue = modelData.spectro.signal
//                            case 2:
//                                sencondScene.selectedValue = modelData.spectro.shiftInCm
//                            case 3:
//                                sencondScene.selectedValue = modelData.spectro.shiftInGhz
//                            case 4:
//                                sencondScene.selectedValue = modelData.spectro.shiftInMev
//                            default:
//                                break
//                            }
//                         } else {
//                            switch mySelection {
//                            case 0:
//                                sencondScene.selectedValue = modelData.spectro.bwLambda
//                            case 1:
//                                sencondScene.selectedValue = modelData.spectro.bwInCm
//                            case 2:
//                                sencondScene.selectedValue = modelData.spectro.bwInGhz
//                            case 3:
//                                sencondScene.selectedValue = modelData.spectro.bwInNm
//                            default:
//                                break
//                            }
//                        }
//                    }
//                } else {
//                    print("ERROR: could not find a textvalue for cell's detailed label!")
//                }
//                
//            }
//        }

//        var sencondScene = segue.destinationViewController as! ChangeValueViewController
//        
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPathForCell(cell)
//        
//        if let indexPath = tableView!.indexPathForSelectedRow {
//            // we're passing raman data information or bandwidth data information to the ChangeValue view
//            sencondScene.selectedDataSource = indexPath.row // represents the index of the value in the values array
//            sencondScene.selectedSection = indexPath!.section // which data set are we working on here? either raman or bandwidth
//            if indexPath!.section == 0 {
//                sencondScene.selectedValue = ramanData[indexPath!.row] // we're passing raman data value
//            } else {
//                sencondScene.selectedValue = bwData[indexPath!.row]  // we're passing bandwidth data value
//            }
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        myTableView.reloadData()
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
//        println("In view did load. New Value is \(newValueForChangedData)")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
 
}


