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
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // localize
        self.title = .bandwidthTitle
        aboutButton.title = .about
        
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
    
    func configureCell(cell: BWCell, indexPath: IndexPath) {
        cell.valueLabel!.text = modelData.spectro.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.dataImageView?.image = RamanStyleKit.imageOfBw0
            cell.unitsLabel.text = "nm"
            cell.exponentLabel.text = ""
        case 1:
            cell.dataImageView?.image = RamanStyleKit.imageOfBw1
            cell.unitsLabel.text = "cm"
            cell.exponentLabel.text = "-1"
        case 2:
            cell.dataImageView?.image = RamanStyleKit.imageOfBw2
            cell.unitsLabel.text = "GHz"
            cell.exponentLabel.text = ""
        case 3:
            cell.dataImageView?.image = RamanStyleKit.imageOfBw3
            cell.unitsLabel.text = "nm"
            cell.exponentLabel.text = ""
        default:
            cell.dataImageView?.image = RamanStyleKit.imageOfBw0
            cell.unitsLabel.text = "nm"
            cell.exponentLabel.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBW", for: indexPath) as! BWCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
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
