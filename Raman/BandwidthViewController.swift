//
//  BandwidthViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class BandwidthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: properties
    
    let modelData = Model.sharedInstance
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the tableview background color (behind the cells)
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        tableView.separatorColor = Theme.Colors.BackgroundColor.color
        
        // fix space on top of tableview
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
// MARK: Table delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(66)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellBW", forIndexPath: indexPath) as! BWCell
        
        cell.valueLabel!.text = modelData.spectro.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]

        cell.imageView?.image = UIImage(named: "bw\(indexPath.row)")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        /* Push the changeValueViewController */
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ChangeValueViewController") as! ChangeValueViewController
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = modelData.spectro.bwData(indexPath.row)
        controller.myUnits = Constants.bwUnits[indexPath.row]
        controller.toolTipString = Constants.bwToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.Bandwidth

        navigationController!.pushViewController(controller, animated: true)
    }
    

}
