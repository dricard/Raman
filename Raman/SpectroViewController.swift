//
//  ViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit
import os.log

class SpectroViewController: UIViewController {
    
    // MARK: - Properties
    
    var Current: Environment?

    var themeModeButton: UIBarButtonItem!

    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: - actions
    
    @objc func themeModeButtonTapped(_ sender: UIBarButtonItem) {
        if let Current = Current {
            Current.colorSet.toggle()
            Current.colorSet.save()
            updateInterface()
        }
    }
    
    func updateInterface() {
        // display theme mode button for this mode
        guard let Current = Current else { return }
        
        UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {
        
            // set navigation bar
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")!]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            self.tabBarController?.tabBar.tintColor = UIColor(named: "\(Current.colorSet.prefix())navBarTextColor")

            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "\(Current.colorSet.prefix())navBarUnselectedTextColor")
            
            // update theme mode switch button
            switch Current.colorSet.mode {
            case .dark:
                self.themeModeButton.image = UIImage(named: "lightModeIcon")
            case .light:
                self.themeModeButton.image = UIImage(named: "darkModeIcon")
            }
            
            // set the tableview background color (behind the cells)
            self.tableView.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())navBarTintColor")
            
            // set the separator color to the same as the background
            self.tableView.separatorColor = UIColor(named: "\(Current.colorSet.prefix())tableViewSeparatorColor")
            

        }, completion: nil)
        
        // update the display with new theme
        tableView.reloadData()
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register observer for value updates from Model
        NotificationCenter.default.addObserver(self, selector: #selector(updateParameter), name: Raman.spectroChangedNotification, object: nil)
        
        // 3D touch
        registerForPreviewing(with: self, sourceView: view)
        
        // localize
        
        aboutButton.title = .about
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // This prevents the space below the cells to have spacers
        tableView.tableFooterView = UIView()
        
        // Remove space at top of tableview
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(SpectroViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
 
        updateInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // update all data
        updateInterface()
    }
    
    // MARK: - Updates to parameters
    
    @objc func updateParameter(_ notification: NSNotification) {
        // receveived a notification of changed value
        if let userInfo = notification.userInfo {
            os_log("Received notification in spectro with userInfo: %s", log: Log.general, type: .info, "\(userInfo)")
            var indexPaths = [IndexPath]()
            if let rowsToUpdate = userInfo["rowsToUpdate"] as? [Int] {
                for row in rowsToUpdate {
                    indexPaths.append(IndexPath(row: row, section: 0))
                }
            }
            DispatchQueue.main.async {
                UIView.transition(with: self.view, duration: 0.8, options: .beginFromCurrentState, animations: {
                    self.tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.left)
                    
                }, completion: nil)
            }
            
        } else {
            os_log("Received notification without userInfo in spectro", log: Log.general, type: .error)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAboutSegue" {
            if let nvc = segue.destination as? UINavigationController, let vc = nvc.topViewController as? PreferencesViewController {
                vc.Current = self.Current
            }
         }
    }
 }

// MARK: - Tableview delegates

extension SpectroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let Current = Current else { return }
        
        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
        
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = Current.raman.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.myExp = Constants.specExp[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.spectroscopy
        controller.Current = Current
         
        navigationController!.pushViewController(controller, animated: true)
    }
}

// MARK: - TableView DataSource

extension SpectroViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let navigationController = navigationController, let tabBarController = tabBarController {
            let rowHeight = ( view.frame.height - navigationController.navigationBar.frame.height - tabBarController.tabBar.frame.height - UIApplication.shared.statusBarFrame.height ) / 5
            print("\(rowHeight)")
            return rowHeight
        } else {
            return CGFloat(99.5)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    @objc func configureCell(cell: DataCell, indexPath: IndexPath) {
        guard let Current = Current else { return }
        
        // current value
        cell.valueLabel!.text = Current.raman.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.valueLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
        
        // parameter name
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        cell.dataLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellLabelTextColor")
        
        // parameter units
        cell.unitsLabel.text = Constants.specUnits[indexPath.row]
        cell.unitsLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
        
        // parameter units exponent
        cell.exponentsLabel.text = Constants.specExp[indexPath.row]
        cell.exponentsLabel.textColor = UIColor(named: "\(Current.colorSet.prefix())cellTextColor")
        
        // cell background color
        cell.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellBackgroundColor")

        // style view behind the value
        cell.valueLabelView.backgroundColor = UIColor.clear
        
        // style view behind cell's label
        cell.labelView.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellLabelBackgroundColor")
        cell.dataImageView.image = UIImage(named: "spectro_\(indexPath.row)")
        cell.dataImageView.layer.cornerRadius = 8
        cell.dataImageView.layer.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())cellLabelBackgroundColor")?.cgColor

        // set images on both sides of cell depending on available data in recents
        switch indexPath.row {
        case 0:
            os_log("configuring cell for excitations with row = %d", log: Log.general, type: .debug, indexPath.row)
            if Current.excitations.left() {
                cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.leftDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
            if Current.excitations.righ() {
                cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.rightDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
        case 1:
            os_log("configuring cell for signals with row = %d", log: Log.general, type: .debug, indexPath.row)
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
        case 2, 3, 4:
            if Current.shifts.left() {
                cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.leftDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
            if Current.shifts.righ() {
                cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            } else {
                cell.rightDataAvailableImageView.image = UIImage(named: "noDataAvailable.png")
            }
        default:
            cell.leftDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
            cell.rightDataAvailableImageView.image = UIImage(named: "dataAvailable.png")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier) as! DataCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }

    // we enable swipe actions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Swipe actions (iOS11+)

extension SpectroViewController {
    
    // this goes left
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let previous = UIContextualAction(style: .normal, title: "previous") { (action, view, completionHandler) in
            if let Current = self.Current {
                
                switch indexPath.row {
                case Constants.excitationIndex:
                    if Current.excitations.moveLeft() {
                        if let spot = Current.excitations.current() {
                            Current.raman.updateParameter(spot.value, forDataSource: Constants.excitationIndex, inWhichTab: .spectroscopy)
                        }
                    }
                case Constants.signalIndex:
                    if Current.signals.moveLeft() {
                        if let spot = Current.signals.current() {
                            Current.raman.updateParameter(spot.value, forDataSource: Constants.signalIndex, inWhichTab: .spectroscopy)
                        }
                    }
                case Constants.shiftCmIndex, Constants.shiftGhzIndex, Constants.shiftmeVIndex:
                    if Current.shifts.moveLeft() {
                        if let spot = Current.shifts.current() {
                            let type = spot.type
                            
                            switch type {
                            case .shiftInCm:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftCmIndex, inWhichTab: .spectroscopy)
                            case .shiftInGhz:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftGhzIndex, inWhichTab: .spectroscopy)
                            case .shiftInMev:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftmeVIndex, inWhichTab: .spectroscopy)
                            default:
                                os_log("Wrong type for shift in leading swipe action", log: Log.general, type: .error)
                            }
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in leading swipe action: %d", log: Log.general, type: .error, indexPath.row)
                }
                
            }
            completionHandler(true)
        }
        if let Current = Current {
            previous.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")
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
                case Constants.excitationIndex:
                    if Current.excitations.moveRight() {
                        if let spot = Current.excitations.current() {
                            Current.raman.updateParameter(spot.value, forDataSource: Constants.excitationIndex, inWhichTab: .spectroscopy)
                        }
                    }
                case Constants.signalIndex:
                    if Current.signals.moveRight() {
                        if let spot = Current.signals.current() {
                            Current.raman.updateParameter(spot.value, forDataSource: Constants.signalIndex, inWhichTab: .spectroscopy)
                        }
                    }
                case Constants.shiftCmIndex, Constants.shiftGhzIndex, Constants.shiftmeVIndex:
                    if Current.shifts.moveRight() {
                        if let spot = Current.shifts.current() {
                            let type = spot.type
                            
                            switch type {
                            case .shiftInCm:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftCmIndex, inWhichTab: .spectroscopy)
                            case .shiftInGhz:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftGhzIndex, inWhichTab: .spectroscopy)
                            case .shiftInMev:
                                Current.raman.updateParameter(spot.value, forDataSource: Constants.shiftmeVIndex, inWhichTab: .spectroscopy)
                            default:
                                os_log("Wrong type for shift in trainling swipe action", log: Log.general, type: .error)
                            }
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in trailing swipe action: %d", log: Log.general, type: .error, indexPath.row)
                }
                
            }
            completionHandler(true)
        }
        if let Current = Current {
            next.backgroundColor = UIColor(named: "\(Current.colorSet.prefix())swipeActionColor")
        }
        let config = UISwipeActionsConfiguration(actions: [next])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

extension SpectroViewController: UIViewControllerPreviewingDelegate {
    
    func recentsForRow(at indexPath: IndexPath) -> Recents? {
        guard let Current = Current else { return nil }
        switch indexPath.row {
        case Constants.excitationIndex:
            return Current.excitations
        case Constants.signalIndex:
            return Current.signals
        default:
            // all other cases are shifts, handled by the same recents
            return Current.shifts
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        // convert location to the tableView's coordinate system to get the right cell
        let locationInTableViewCoordinate = view.convert(location, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableViewCoordinate), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        os_log("3D touch event in spectro for row %d", log: Log.general, type: .info, indexPath.row)
        let frame = tableView.convert(cell.frame, to: view)
        previewingContext.sourceRect = frame
        let recentsController = storyboard?.instantiateViewController(withIdentifier: "RecentsViewController") as! RecentsViewController
        recentsController.Current = Current
        if let recents = recentsForRow(at: indexPath) {
            recentsController.recents = recents
        }
        recentsController.currentTab = .spectroscopy
        switch indexPath.row {
        case Constants.excitationIndex:
            recentsController.recentsTitle = "Excitations"
        case Constants.signalIndex:
            recentsController.recentsTitle = "Signals"
        default:
            // all other cases are shifts, handled by the same recents
            recentsController.recentsTitle = "Shifts"
        }
        
        recentsController.loadViewIfNeeded()
        
        return recentsController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
