//
//  ViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK: - Properties
    
    let modelData = Model.sharedInstance
    
    var valueDidChangeFromEdit = false
    var whichSectionValueChanged : Int = 0
    var whichDataValueChanged : Int = 0
    var newValueForChangedData : Double = 0.0
    
    // MARK: - Outlets
    
    @IBOutlet var myTableView: UITableView!
    
    // MARK: - Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user's data

        if let signal = NSUserDefaults.standardUserDefaults().valueForKey("signal") {
            modelData.spectro.signal = Double(signal as! NSNumber)
        } else {
            NSUserDefaults.standardUserDefaults().setDouble(modelData.spectro.signal, forKey: "signal")
        }
        if let pump = NSUserDefaults.standardUserDefaults().valueForKey("pump") {
            modelData.spectro.pump = Double(pump as! NSNumber)
        } else {
            NSUserDefaults.standardUserDefaults().setDouble(modelData.spectro.pump, forKey: "pump")
        }
        if let bwLambda = NSUserDefaults.standardUserDefaults().valueForKey("bwLambda") {
            modelData.spectro.bwLambda = Double(bwLambda as! NSNumber)
        } else {
            NSUserDefaults.standardUserDefaults().setDouble(modelData.spectro.bwLambda, forKey: "bwLambda")
        }
        if let bwInCm = NSUserDefaults.standardUserDefaults().valueForKey("bwInCm") {
            modelData.spectro.bwInCm = Double(bwInCm as! NSNumber)
        } else {
            NSUserDefaults.standardUserDefaults().setDouble(modelData.spectro.bwInCm, forKey: "bwInCm")
        }
       
        
        // set the tableview background color (behind the cells)
        myTableView.backgroundColor = Theme.Colors.BackgroundColor.color
        
        // This prevents the space below the cells to have spacers
        myTableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        myTableView.separatorColor = Theme.Colors.BackgroundColor.color
        
        // set tableView delegates
        myTableView.delegate = self
        myTableView.dataSource = self

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // udate all data
        myTableView.reloadData()
    }
    
    
    // MARK: - Tableview delegates
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DataCell.reuseIdentifier) as! DataCell

        cell.textLabel!.text = modelData.spectro.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.detailTextLabel?.text = Constants.ramanShift[indexPath.row]
        cell.imageView?.image = Constants.cellImage[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ChangeValueViewController") as! ChangeValueViewController

        controller.selectedDataSource = indexPath.row
        controller.selectedValue = modelData.spectro.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.Spectroscopy
        
        navigationController!.pushViewController(controller, animated: true)
    }

 
}
