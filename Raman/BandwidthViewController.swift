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
        tableView.backgroundColor = Theme.Colors.backgroundColor.color
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        tableView.separatorColor = Theme.Colors.backgroundColor.color
        
        // fix space on top of tableview
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
// MARK: Table delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(66)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBW", for: indexPath) as! BWCell
        
        cell.valueLabel!.text = modelData.spectro.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]

        cell.imageView?.image = UIImage(named: "bw\(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /* Push the changeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "ChangeValueViewController") as! ChangeValueViewController
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = modelData.spectro.bwData(indexPath.row)
        controller.myUnits = Constants.bwUnits[indexPath.row]
        controller.toolTipString = Constants.bwToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.bandwidth

        navigationController!.pushViewController(controller, animated: true)
    }
    

}
