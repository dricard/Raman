//
//  ViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - Properties
    
    @objc let modelData = Model.sharedInstance
    
    @objc var valueDidChangeFromEdit = false
    @objc var whichSectionValueChanged : Int = 0
    @objc var whichDataValueChanged : Int = 0
    @objc var newValueForChangedData : Double = 0.0
    
    // MARK: - Outlets
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    // MARK: - Life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // localize
        
        aboutButton.title = .about
        
        loadUserPrefs()
       
        
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
    
    // MARK: - Utilities
    
    fileprivate func loadUserPrefs() {
        // Load user's data
        
        let signal = UserDefaults.standard.double(forKey: "signal")
        if signal != 0 {
            modelData.spectro.signal = signal
        } else {
            UserDefaults.standard.set(modelData.spectro.signal, forKey: "signal")
        }
        let pump = UserDefaults.standard.double(forKey: "pump")
        if pump != 0 {
            modelData.spectro.pump = pump
        } else {
            UserDefaults.standard.set(modelData.spectro.pump, forKey: "pump")
        }
        let bwLambda = UserDefaults.standard.double(forKey: "bwLambda")
        if bwLambda != 0 {
            modelData.spectro.bwLambda = bwLambda
        } else {
            UserDefaults.standard.set(modelData.spectro.bwLambda, forKey: "bwLambda")
        }
        let bwInCm = UserDefaults.standard.double(forKey: "bwInCm")
        if bwInCm != 0 {
            modelData.spectro.bwInCm = bwInCm
        } else {
            UserDefaults.standard.set(modelData.spectro.bwInCm, forKey: "bwInCm")
        }
    }
}
    // MARK: - Tableview delegates

extension ViewController: UITableViewDelegate {
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

// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    @objc func configureCell(cell: DataCell, indexPath: IndexPath) {
        cell.valueLabel!.text = modelData.spectro.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        cell.dataImageView?.image = UIImage(named: "spectro\(indexPath.row)")
        cell.unitsLabel.text = Constants.specUnits[indexPath.row]
        cell.exponentsLabel.text = Constants.specExp[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier) as! DataCell

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
}
