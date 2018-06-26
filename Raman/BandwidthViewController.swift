//
//  BandwidthViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class BandwidthViewController: UIViewController {

    // MARK: properties
    
    var Current: Environment?

    var themeModeButton: UIBarButtonItem!

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    @objc func themeModeButtonTapped(_ sender: UIBarButtonItem) {
        if let Current = Current {
            switch Current.selectedTheme.mode {
            case .darkMode:
                Current.selectedTheme.mode = .lightMode
            case .lightMode:
                Current.selectedTheme.mode = .darkMode
            }
            UserDefaults.standard.set(Current.selectedTheme.mode.rawValue, forKey: "themeMode")
            updateInterface()
        }
    }
    
    func updateInterface() {
        guard let Current = Current else { return }
        
        // display theme mode button for this mode
        UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {

        // set navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor")
        self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")!]
        
        
        // set tab bar
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
        self.tabBarController?.tabBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarUnselectedTextColor")
         
        // update theme mode switch button
        switch Current.selectedTheme.mode {
        case .darkMode:
            self.themeModeButton.image = UIImage(named: "lightModeIcon")
        case .lightMode:
            self.themeModeButton.image = UIImage(named: "darkModeIcon")
        }
        
        // set the tableview background color (behind the cells)
        self.tableView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())tableViewBackgroundColor")
        
        // set the separator color to the same as the background
        self.tableView.separatorColor = UIColor(named: "\(Current.selectedTheme.prefix())tableViewSeparatorColor")
            
        }, completion: nil)
        
        // update the display with new them
        tableView.reloadData()
    }
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // localize
        self.title = .bandwidthTitle
        aboutButton.title = .about
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // fix space on top of tableview
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(BandwidthViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
        
        updateInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInterface()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAboutSegue" {
             }
        }
    

}

// MARK: TableView DataSource

extension BandwidthViewController: UITableViewDataSource {
    
    @objc func configureCell(cell: BWCell, indexPath: IndexPath) {
        guard let Current = Current else { return }
        
        cell.valueLabel!.text = Current.raman.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.dataImageView?.image = UIImage(named: "bw\(indexPath.row)")
        cell.unitsLabel.text = Constants.bwUnits[indexPath.row]
        cell.exponentLabel.text = Constants.bwEpx[indexPath.row]
        cell.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellBackgroundColor")
        cell.valueLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.dataLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.unitsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.exponentLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        if Current.selectedTheme.mode == .darkMode {
            cell.dataImageView?.image = UIImage(named: "bw\(indexPath.row)")
        } else {
            cell.dataImageView?.image = UIImage(named: "bw_light\(indexPath.row)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBW", for: indexPath) as! BWCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

extension BandwidthViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let Current = Current else { return }
        
        /* Push the changeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController

        controller.selectedDataSource = indexPath.row
        controller.selectedValue = Current.raman.bwData(indexPath.row)
        controller.myUnits = Constants.bwUnits[indexPath.row]
        controller.myExp = Constants.bwEpx[indexPath.row]
        controller.toolTipString = Constants.bwToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.bandwidth
        controller.raman = Current.raman
        controller.selectedTheme = Current.selectedTheme
        controller.memory = Current.memory
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Swipe actions (iOS11+)

extension BandwidthViewController {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let previous = UIContextualAction(style: .normal, title: "previous") { (action, view, completionHandler) in
            if let Current = self.Current {
                let newValue = Current.memory.previous(dataSource: .bandwidth, parameter: indexPath.row)
                if newValue != 0.0 {
                    Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .bandwidth)
                    tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        if let Current = Current {
            previous.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())swipeActionColor")
        }
        let config = UISwipeActionsConfiguration(actions: [previous])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let next = UIContextualAction(style: .normal, title: "next") { (action, view, completionHandler) in
            if let Current = self.Current {
                let newValue = Current.memory.next(dataSource: .bandwidth, parameter: indexPath.row)
                if newValue != 0.0 {
                    Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .bandwidth)
                    tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        if let Current = Current {
            next.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())swipeActionColor")
        }
        let config = UISwipeActionsConfiguration(actions: [next])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

