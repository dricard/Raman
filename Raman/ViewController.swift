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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();

        NSLog("[DEBUG] table frame: %@", NSStringFromCGRect(myTableView.frame));
    }


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

//* Unneeded; done in storyboard.  TEO
//        // set tableView delegates
//        myTableView.delegate = self
//        myTableView.dataSource = self

        myTableView.backgroundColor = UIColor.magentaColor();                   //* TEO DEBUG
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // udate all data
        myTableView.reloadData()
    }
    
    
    // MARK: - Tableview delegates
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 //* TEO was: 44
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count * 2                                   //* TEO Debug: double the rows, so we can see how table scrolls
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DataCell.reuseIdentifier) as! DataCell

        let row = indexPath.row % Constants.ramanShift.count
        cell.textLabel!.text = modelData.spectro.specData(row).format(Constants.specRounding[row])
        cell.detailTextLabel?.text = Constants.ramanShift[row]

        cell.imageView?.image = UIImage(named: "spectro\(row)")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ChangeValueViewController") as! ChangeValueViewController

        let row = indexPath.row % Constants.ramanShift.count
        controller.selectedDataSource = row
        controller.selectedValue = modelData.spectro.specData(row)
        controller.myUnits = Constants.specUnits[row]
        controller.toolTipString = Constants.specToolTip[row]
        controller.whichTab = Raman.DataSourceType.Spectroscopy
        
        navigationController!.pushViewController(controller, animated: true)
    }

 
}
