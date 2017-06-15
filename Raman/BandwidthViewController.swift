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
    var selectedTheme: Theme.ThemeModes?
    var themeModeButton: UIBarButtonItem!
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    func themeModeButtonTapped(_ sender: UIBarButtonItem) {
        if let selectedTheme = selectedTheme {
            switch selectedTheme {
            case .darkMode:
                self.selectedTheme = .lightMode
            case .lightMode:
                self.selectedTheme = .darkMode
            }
            updateThemeModeButton()
        }
    }
    
    func updateThemeModeButton() {
        // display theme mode button for this mode
        guard let selectedTheme = selectedTheme else { return }
        
        switch selectedTheme {
        case .darkMode:
            themeModeButton.image = UIImage(named: "lightModeIcon")
        case .lightMode:
            themeModeButton.image = UIImage(named: "darkModeIcon")
        }
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

        // set the tableview background color (behind the cells)
        tableView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: .darkMode)
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        tableView.separatorColor = Theme.color(for: .tableViewSeparatorColor, with: .darkMode)
        
        // fix space on top of tableview
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(ViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
        
        updateThemeModeButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let vc = navController.topViewController as? DisplayInfoViewController else { return }
        vc.selectedTheme = selectedTheme
    }
    
}

// MARK: TableView DataSource

extension BandwidthViewController: UITableViewDataSource {
    
    @objc func configureCell(cell: BWCell, indexPath: IndexPath) {
        guard let raman = raman else { return }
        
        cell.valueLabel!.text = raman.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.dataImageView?.image = UIImage(named: "bw\(indexPath.row)")
        cell.unitsLabel.text = Constants.bwUnits[indexPath.row]
        cell.exponentLabel.text = Constants.bwEpx[indexPath.row]
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
        let controller = storyboard!.instantiateViewController(withIdentifier: "ChangeValueViewController") as! ChangeValueViewController
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = raman.bwData(indexPath.row)
        controller.myUnits = Constants.bwUnits[indexPath.row]
        controller.myExp = Constants.bwEpx[indexPath.row]
        controller.toolTipString = Constants.bwToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.bandwidth
        controller.raman = raman
        controller.selectedTheme = selectedTheme

        navigationController!.pushViewController(controller, animated: true)
    }
    

}
