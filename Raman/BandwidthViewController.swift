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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
// MARK: Table delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellBW", forIndexPath: indexPath)
        
        cell.textLabel!.text = "\(modelData.spectro.bwData(indexPath.row))"
        cell.detailTextLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.imageView?.image = Constants.bwCellImage[indexPath.row]

        return cell
    }
    
}
