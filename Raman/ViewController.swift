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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        cell.textLabel!.text = "\(modelData.spectro.specData(indexPath.row))"
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

        navigationController!.pushViewController(controller, animated: true)
    }

    
 
}


