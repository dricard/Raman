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

        if let signal = UserDefaults.standard.value(forKey: "signal") {
            modelData.spectro.signal = Double(signal as! NSNumber)
        } else {
            UserDefaults.standard.set(modelData.spectro.signal, forKey: "signal")
        }
        if let pump = UserDefaults.standard.value(forKey: "pump") {
            modelData.spectro.pump = Double(pump as! NSNumber)
        } else {
            UserDefaults.standard.set(modelData.spectro.pump, forKey: "pump")
        }
        if let bwLambda = UserDefaults.standard.value(forKey: "bwLambda") {
            modelData.spectro.bwLambda = Double(bwLambda as! NSNumber)
        } else {
            UserDefaults.standard.set(modelData.spectro.bwLambda, forKey: "bwLambda")
        }
        if let bwInCm = UserDefaults.standard.value(forKey: "bwInCm") {
            modelData.spectro.bwInCm = Double(bwInCm as! NSNumber)
        } else {
            UserDefaults.standard.set(modelData.spectro.bwInCm, forKey: "bwInCm")
        }
       
        
        // set the tableview background color (behind the cells)
        myTableView.backgroundColor = Theme.Colors.backgroundColor.color
        
        // This prevents the space below the cells to have spacers
        myTableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        myTableView.separatorColor = Theme.Colors.backgroundColor.color

        // Remove space at top of tableview
        myTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // udate all data
        myTableView.reloadData()
    }
    
    
    // MARK: - Tableview delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    func configureCell(cell: DataCell, indexPath: IndexPath) {
        cell.valueLabel!.text = modelData.spectro.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro0
            cell.unitsLabel.text = "nm"
            cell.exponentsLabel.text = ""
        case 1:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro1
            cell.unitsLabel.text = "nm"
            cell.exponentsLabel.text = ""
        case 2:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro2
            cell.unitsLabel.text = "cm"
            cell.exponentsLabel.text = "-1"
        case 3:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro3
            cell.unitsLabel.text = "GHz"
            cell.exponentsLabel.text = ""
        case 4:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro4
            cell.unitsLabel.text = "meV"
            cell.exponentsLabel.text = ""
        default:
            cell.dataImageView?.image = RamanStyleKit.imageOfSpectro0
            cell.unitsLabel.text = "nm"
            cell.exponentsLabel.text = ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier) as! DataCell

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "ChangeValueViewController") as! ChangeValueViewController


        controller.selectedDataSource = indexPath.row
        controller.selectedValue = modelData.spectro.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.spectroscopy
        
        navigationController!.pushViewController(controller, animated: true)
    }

 
}
