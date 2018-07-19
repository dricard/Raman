//
//  BandwidthViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import os.log

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
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
        self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")!]
        
        
            // set tab bar
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
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
        self.tableView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
        
        // set the separator color to the same as the background
        self.tableView.separatorColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor\(Current.colorSet.suffix())")
            
        }, completion: nil)
        
        // update the display with new them
        tableView.reloadData()
    }
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 3D touch
        registerForPreviewing(with: self, sourceView: view)

        // localize
        self.title = .bandwidthTitle
        aboutButton.title = .about
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // fix space on top of tableview
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(BandwidthViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
        
        updateInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let Current = Current else { return }
        
        if let value = Current.signals.current().value {
            os_log("setting bandwidth wavelength to current signals track", log: Log.general, type: .info)
        Current.raman.updateParameter(value, forDataSource: 0, inWhichTab: .bandwidth)
        } else {
            os_log("invalid value for current signal value in bandwidth", log: Log.general, type: .error)
        }
        
        updateInterface()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAboutSegue" {
            if let nvc = segue.destination as? UINavigationController, let vc = nvc.topViewController as? DisplayInfoViewController {
                vc.Current = self.Current
            }
        }
    }


}

// MARK: TableView DataSource

extension BandwidthViewController: UITableViewDataSource {
    
    @objc func configureCell(cell: DataCell, indexPath: IndexPath) {
        guard let Current = Current else { return }
        
        // current value
        cell.valueLabel!.text = Current.raman.bwData(indexPath.row).format(Constants.bwRounding[indexPath.row])
        cell.valueLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")

        // parameter name
        cell.dataLabel?.text = Constants.ramanBandwidth[indexPath.row]
        cell.dataLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellLabelTextColor\(Current.colorSet.suffix())")
        
        // parameter units
        cell.unitsLabel.text = Constants.bwUnits[indexPath.row]
        cell.unitsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")
        
        // parameter units exponent
        cell.exponentsLabel.text = Constants.bwEpx[indexPath.row]
        cell.exponentsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")

        // cell background color
        cell.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellBackgroundColor\(Current.colorSet.suffix())")

        // style view behind the value
        cell.valueLabelView.backgroundColor = UIColor.clear

        // style view behind cell's label
        cell.labelView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellLabelBackgroundColor\(Current.colorSet.suffix())")
        
        // row icon
        cell.dataImageView.image = UIImage(named: "bw_\(indexPath.row)")
        cell.dataImageView.layer.cornerRadius = 8
        cell.dataImageView.layer.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellLabelBackgroundColor\(Current.colorSet.suffix())")?.cgColor

        
        // style view behind cell's label
        cell.labelView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellLabelBackgroundColor\(Current.colorSet.suffix())")

        // set images on both sides of cell depending on available data in recents
        switch indexPath.row {
        case 0:
            os_log("configuring cell for bandwidth signal with row = %d", log: Log.general, type: .debug, indexPath.row)
            if Current.signals.left() {
                cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.leftDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
            if Current.signals.righ() {
                cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.rightDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
        case 1, 2, 3:
            os_log("configuring cell for bandwidth with row = %d", log: Log.general, type: .debug, indexPath.row)
            if Current.bandwidths.left() {
                cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.leftDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
            if Current.bandwidths.righ() {
                cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.rightDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
         default:
            cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanBandwidth.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(99.5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier, for: indexPath) as! DataCell
        
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
        controller.Current = Current
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Swipe actions (iOS11+)

extension BandwidthViewController {
    
    // this goes left
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let previous = UIContextualAction(style: .normal, title: "previous") { (action, view, completionHandler) in
            if let Current = self.Current {
                
                switch indexPath.row {
                case 0:
                    if Current.signals.moveLeft() {
                        if let newValue = Current.signals.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .bandwidth)
                            tableView.reloadData()
                        }
                    }
                case 1, 2, 3:
                    if Current.bandwidths.moveLeft() {
                        if let newValue = Current.bandwidths.current().value {
                            let type = Current.bandwidths.current().type
                            
                            switch type {
                            case .bandwidthInCm:
                                Current.raman.updateParameter(newValue, forDataSource: 1, inWhichTab: .bandwidth)
                            case .bandwidthInNm:
                                Current.raman.updateParameter(newValue, forDataSource: 2, inWhichTab: .bandwidth)
                            case .bandwidthInGhz:
                                Current.raman.updateParameter(newValue, forDataSource: 3, inWhichTab: .bandwidth)
                            default:
                                os_log("Wrong type for bandwidth in lead swipe action", log: Log.general, type: .error)
                            }
                            tableView.reloadData()
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in bandwidth lead swipe action: %d", log: Log.general, type: .error, indexPath.row)
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
    
    // this goes right
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let next = UIContextualAction(style: .normal, title: "next") { (action, view, completionHandler) in
            if let Current = self.Current {

                switch indexPath.row {
                case 0:
                    if Current.signals.moveRight() {
                        if let newValue = Current.signals.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .bandwidth)
                            tableView.reloadData()
                        }
                    }
                case 1, 2, 3:
                    if Current.bandwidths.moveRight() {
                        if let newValue = Current.bandwidths.current().value {
                            let type = Current.bandwidths.current().type
                            
                            switch type {
                            case .bandwidthInCm:
                                Current.raman.updateParameter(newValue, forDataSource: 1, inWhichTab: .bandwidth)
                            case .bandwidthInNm:
                                Current.raman.updateParameter(newValue, forDataSource: 2, inWhichTab: .bandwidth)
                            case .bandwidthInGhz:
                                Current.raman.updateParameter(newValue, forDataSource: 3, inWhichTab: .bandwidth)
                            default:
                                os_log("Wrong type for bandwidth in trainling swipe action", log: Log.general, type: .error)
                            }
                            tableView.reloadData()
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in bandwidth trailing swipe action: %d", log: Log.general, type: .error, indexPath.row)
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

extension BandwidthViewController: UIViewControllerPreviewingDelegate {
    
    func recentsForRow(at indexPath: IndexPath) -> Recents? {
        guard let Current = Current else { return nil }
        switch indexPath.row {
        case 0:
            return Current.signals
        default:
            return Current.bandwidths
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // convert location to the tableView's coordinate system to get the right cell
        let locationInTableViewCoordinate = view.convert(location, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableViewCoordinate), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        os_log("3D touch event in bandwidth for row %d", log: Log.general, type: .info, indexPath.row)
        let frame = tableView.convert(cell.frame, to: view)
        previewingContext.sourceRect = frame
        let recentsController = storyboard?.instantiateViewController(withIdentifier: "RecentsViewController") as! RecentsViewController
        recentsController.Current = Current
        if let recents = recentsForRow(at: indexPath) {
            recentsController.recents = recents
        }
        recentsController.currentTab = .bandwidth
        switch indexPath.row {
        case 0:
            recentsController.recentsTitle = "Signals"
         default:
            recentsController.recentsTitle = "Bandwidths"
        }
        
        recentsController.loadViewIfNeeded()
        
        return recentsController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
