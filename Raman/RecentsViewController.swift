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
    
    // MARK: - Utilities
    
    func fontSizeClasses() -> [CGFloat] {
        switch view.frame.width {
        case 0...320:
            let fontSizes: [CGFloat] = [12, 16, 13, 25, 40, 96]
            return fontSizes
        case 321...375:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40, 96]
            return fontSizes
        case 376...414:
            let fontSizes: [CGFloat] = [12, 16, 22, 25, 40, 96]
            return fontSizes
        case 415...768:
            let fontSizes: [CGFloat] = [25, 24, 32, 40, 72, 96]
            return fontSizes
        case 1024...:
            let fontSizes: [CGFloat] = [25, 32, 40, 50, 96, 120]
            return fontSizes
        default:
            let fontSizes: [CGFloat] = [12, 16, 19, 25, 40, 60]
            return fontSizes
        }
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let recentsTitle = recentsTitle {
            title = recentsTitle
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        if let Current = Current {
            tableView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())tableViewBackgroundColor")
        }
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        tableView.reloadData()
    }
    
}

extension RecentsViewController: UITableViewDataSource {
    
    func configureCell(cell: RecentsTableViewCell) {
        guard let Current = Current else { return }
        
        cell.valueLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.unitsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.exponentLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellBackgroundColor")

    }
    
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

        configureCell(cell: cell)
        
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
