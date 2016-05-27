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
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellBW", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 0 :
            cell.textLabel!.text = "\(modelData.spectro.bwLambda)"
        case 1 :
            cell.textLabel!.text = "\(modelData.spectro.bwInCm)"
        case 2 :
            cell.textLabel!.text = "\(modelData.spectro.bwInGhz)"
        case 3 :
            cell.textLabel!.text = "\(modelData.spectro.bwInNm)"
        default :
            break
        }
        cell.detailTextLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.imageView?.image = Constants.bwCellImage[indexPath.row]

        return cell
    }
    
}