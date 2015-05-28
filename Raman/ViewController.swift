//
//  ViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    let ramanShift = ["1. Excitation wavelenth (nm)", "2. Signal wavelength (nm)", "3. Raman shift (cm-1)", "4. Raman shift (GHz)", "5. Raman shift (meV)"]
    
    let ramanBandwidth = ["6. Wavelength for bw calculations (nm)", "7. Bandwidth (cm-1)", "8. Bandwidth (GHz)", "9. Bandwidth (nm)"]
    
    let cellImage = [UIImage(named: "excitationInNmIcon"), UIImage(named: "signalInNmIcon"), UIImage(named: "shiftInCmIcon"), UIImage(named: "shiftInGhzIcon"), UIImage(named: "shiftInMevIcon"), UIImage(named: "bwInCmIcon"), UIImage(named: "bwInGhzIcon"), UIImage(named: "bwInNmIcon")]
   
    var valueDidChangeFromEdit = false
    var whichSectionValueChanged : Int = 0
    var whichDataValueChanged : Int = 0
    var newValueForChangedData : Double = 0.0
    
    @IBOutlet var myTableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ramanShift.count
        } else {
            return ramanBandwidth.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        // var myImage = UIImage(named: "placeHolderImage")
        
        if indexPath.section == 0 {
            // we're in the raman signal section
            switch indexPath.row {
            case 0 :
                cell.textLabel!.text = "\(appDelegate.spectro.pump)"
                cell.detailTextLabel?.text = ramanShift[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            case 1 :
                cell.textLabel!.text = "\(appDelegate.spectro.signal)"
                cell.detailTextLabel?.text = ramanShift[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            case 2 :
                cell.textLabel!.text = "\(appDelegate.spectro.shiftInCm)"
                cell.detailTextLabel?.text = ramanShift[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            case 3 :
                cell.textLabel!.text = "\(appDelegate.spectro.shiftInGhz)"
                cell.detailTextLabel?.text = ramanShift[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            case 4 :
                cell.textLabel!.text = "\(appDelegate.spectro.shiftInMev)"
                cell.detailTextLabel?.text = ramanShift[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            default :
                break
            }
        } else {
            // we're in the raman bandwith section
            switch indexPath.row {
            case 0 :
                cell.textLabel!.text = "\(appDelegate.spectro.bwLambda)"
                cell.detailTextLabel?.text = ramanBandwidth[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row]
            case 1 :
                cell.textLabel!.text = "\(appDelegate.spectro.bwInCm)"
                cell.detailTextLabel?.text = ramanBandwidth[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row + 4]
            case 2 :
                cell.textLabel!.text = "\(appDelegate.spectro.bwInGhz)"
                cell.detailTextLabel?.text = ramanBandwidth[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row + 4]
            case 3 :
                cell.textLabel!.text = "\(appDelegate.spectro.bwInNm)"
                cell.detailTextLabel?.text = ramanBandwidth[indexPath.row]
                cell.imageView?.image = cellImage[indexPath.row + 4]
            default :
                break
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Raman Spectroscopy"
        } else {
            return "Bandwidth Conversion"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println("into prepareForSegue")
        if segue.identifier != nil {
            // println("Segue identifier is \(segue.identifier)")
            if segue.identifier! == "changeData" {
                // println("-- we're in the loop!! --")
                var sencondScene = segue.destinationViewController as! ChangeValueViewController
                let cell = sender as! UITableViewCell
                if let myData = cell.detailTextLabel!.text {
                    // println(myData)
                    // println(myData[myData.startIndex])
                    let temp : String = String(myData[myData.startIndex])
                    if let cellSelected = temp.toInt() {
                        var mySelection = cellSelected
                        var sectionSelected : Int
                        if cellSelected > 5 {
                            mySelection = cellSelected - 6
                            sectionSelected = 1
                        } else {
                            mySelection = cellSelected - 1
                            sectionSelected = 0
                        }
                        sencondScene.selectedDataSource = mySelection  // represents the index of the value in the values array
                        
                        sencondScene.selectedSection = sectionSelected // which data set are we working on here? either raman or
                        
                        if sectionSelected == 0 {
                            switch mySelection {
                            case 0:
                                sencondScene.selectedValue = appDelegate.spectro.pump
                            case 1:
                                sencondScene.selectedValue = appDelegate.spectro.signal
                            case 2:
                                sencondScene.selectedValue = appDelegate.spectro.shiftInCm
                            case 3:
                                sencondScene.selectedValue = appDelegate.spectro.shiftInGhz
                            case 4:
                                sencondScene.selectedValue = appDelegate.spectro.shiftInMev
                            default:
                                break
                            }
                         } else {
                            switch mySelection {
                            case 0:
                                sencondScene.selectedValue = appDelegate.spectro.bwLambda
                            case 1:
                                sencondScene.selectedValue = appDelegate.spectro.bwInCm
                            case 2:
                                sencondScene.selectedValue = appDelegate.spectro.bwInGhz
                            case 3:
                                sencondScene.selectedValue = appDelegate.spectro.bwInNm
                            default:
                                break
                            }
                        }
                    }
                } else {
                    println("ERROR: could not find a textvalue for cell's detailed label!")
                }
                
            }
        }

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
    }
        
    override func viewWillAppear(animated: Bool) {
        myTableView.reloadData()
    }
    
     override func viewDidLoad() {
        
//        println("In view did load. New Value is \(newValueForChangedData)")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
}


