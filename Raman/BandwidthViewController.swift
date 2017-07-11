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
    
    var raman: Raman?
    var selectedTheme: ThemeMode?
    var themeModeButton: UIBarButtonItem!
    var memory : Memory?

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    @objc func themeModeButtonTapped(_ sender: UIBarButtonItem) {
        if let selectedTheme = selectedTheme {
            switch selectedTheme.mode {
            case .darkMode:
                self.selectedTheme?.mode = .lightMode
            case .lightMode:
                self.selectedTheme?.mode = .darkMode
            }
            UserDefaults.standard.set(selectedTheme.mode.rawValue, forKey: "themeMode")
            updateInterface()
        }
    }
    
    func updateInterface() {
        guard let selectedTheme = selectedTheme else { return }
        
        // display theme mode button for this mode
        UIView.transition(with: self.view, duration: 1.0, options: .beginFromCurrentState, animations: {

        // set navigation bar
        self.navigationController?.navigationBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        self.navigationController?.navigationBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Theme.color(for: .navBarTextColor, with: selectedTheme.mode)]
        
        
        // set tab bar
        self.tabBarController?.tabBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        self.tabBarController?.tabBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        if #available(iOS 10.0, *) {
            self.tabBarController?.tabBar.unselectedItemTintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        } else {
            // Fallback on earlier versions
        }
        
        // update theme mode switch button
        switch selectedTheme.mode {
        case .darkMode:
            self.themeModeButton.image = UIImage(named: "lightModeIcon")
        case .lightMode:
            self.themeModeButton.image = UIImage(named: "darkModeIcon")
        }
        
        // set the tableview background color (behind the cells)
        self.tableView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: selectedTheme.mode)
        
        // set the separator color to the same as the background
        self.tableView.separatorColor = Theme.color(for: .tableViewSeparatorColor, with: selectedTheme.mode)
            
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
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }

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
    
}

// MARK: TableView DataSource

extension BandwidthViewController: UITableViewDataSource {
    
    @objc func configureCell(cell: BWCell, indexPath: IndexPath) {
        guard let raman = raman, let selectedTheme = selectedTheme else { return }
        
        cell.valueLabel!.text = raman.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.dataImageView?.image = UIImage(named: "bw\(indexPath.row)")
        cell.unitsLabel.text = Constants.bwUnits[indexPath.row]
        cell.exponentLabel.text = Constants.bwEpx[indexPath.row]
        cell.backgroundColor = Theme.color(for: .cellBackgroundColor, with: selectedTheme.mode)
        cell.valueLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.dataLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.unitsLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.exponentLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        if selectedTheme.mode == .darkMode {
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
        
        guard let raman = raman else { return }
        
        /* Push the changeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController

        controller.selectedDataSource = indexPath.row
        controller.selectedValue = raman.bwData(indexPath.row)
        controller.myUnits = Constants.bwUnits[indexPath.row]
        controller.myExp = Constants.bwEpx[indexPath.row]
        controller.toolTipString = Constants.bwToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.bandwidth
        controller.raman = raman
        controller.selectedTheme = selectedTheme
        controller.memory = memory
        
        navigationController!.pushViewController(controller, animated: true)
    }
    

}
