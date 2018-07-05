//
//  RecentsViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-05.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import UIKit
import os.log

class RecentsViewController: UIViewController {

    // MARK: - properties
    
    var Current: Environment?
    var recents: Recents?
    var recentsTitle: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let recentsTitle = recentsTitle {
            title = recentsTitle
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()

//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        tableView.reloadData()
    }
    
}

extension RecentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recents = recents else { return 0 }
        os_log("returning number of rows for recents tableview to %d", log: Log.general, type: .info, recents.stack.count)
        return recents.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentsTableViewCell.reuseIdentifier!) as! RecentsTableViewCell
        
        guard let recents = recents, let value = recents.valueFor(indexPath.row) else { return cell }

        let type = recents.typeFor(indexPath.row)
        
        switch type {
        case .wavelength:
            cell.unitsLabel.text = "nm"
            cell.exponentLabel.text = ""
            cell.valueLabel.text = "\(value.format(Constants.specRounding[0]))"
        case .shiftInCm:
            cell.unitsLabel.text = "cm"
            cell.exponentLabel.text = "-1"
            cell.valueLabel.text = "\(value.format(Constants.specRounding[2]))"
        case .shiftInGhz:
            cell.unitsLabel.text = "GHz"
            cell.exponentLabel.text = ""
            cell.valueLabel.text = "\(value.format(Constants.specRounding[3]))"
        case .shiftInMev:
            cell.unitsLabel.text = "MeV"
            cell.exponentLabel.text = ""
            cell.valueLabel.text = "\(value.format(Constants.specRounding[4]))"
        case .bandwidthInCm:
            cell.unitsLabel.text = "cm"
            cell.exponentLabel.text = "-1"
            cell.valueLabel.text = "\(value.format(Constants.bwRounding[1]))"
        case .bandwidthInGhz:
            cell.unitsLabel.text = "GHz"
            cell.exponentLabel.text = ""
            cell.valueLabel.text = "\(value.format(Constants.bwRounding[2]))"
        case .bandwidthInNm:
            cell.unitsLabel.text = "nm"
            cell.exponentLabel.text = ""
            cell.valueLabel.text = "\(value.format(Constants.bwRounding[3]))"
        }
        
        return cell
        
    }
    
    
}
