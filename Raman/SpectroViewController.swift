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
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: - actions
    
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
        // display theme mode button for this mode
        guard let Current = Current else { return }
        
        UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {
            
            // set navigation bar
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor")
            self.navigationController?.navigationBar.tintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "\(Current.selectedTheme.prefix())navBarTextColor")!]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = UIColor(named: "\(Current.selectedTheme.prefix())navBarTintColor")
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
            self.myTableView.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())tableViewBackgroundColor")
            
            // set the separator color to the same as the background
            self.myTableView.separatorColor = UIColor(named: "\(Current.selectedTheme.prefix())tableViewSeparatorColor")
            
        }, completion: nil)
        
        // update the display with new them
        myTableView.reloadData()
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localize
        
        aboutButton.title = .about
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // This prevents the space below the cells to have spacers
        myTableView.tableFooterView = UIView()
        
        // Remove space at top of tableview
        myTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(SpectroViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
 
        updateInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // udate all data
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
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    @objc func configureCell(cell: DataCell, indexPath: IndexPath) {
        guard let Current = Current else { return }
        cell.valueLabel!.text = Current.raman.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.valueLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        cell.dataLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.unitsLabel.text = Constants.specUnits[indexPath.row]
        cell.unitsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.exponentsLabel.text = Constants.specExp[indexPath.row]
        cell.exponentsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor")
        cell.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellBackgroundColor")
        if Current.selectedTheme.mode == .darkMode {
            cell.dataImageView?.image = UIImage(named: "spectro\(indexPath.row)")
        } else {
            cell.dataImageView?.image = UIImage(named: "spectro_light\(indexPath.row)")
        }
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
                case 0:
                    if Current.excitations.moveLeft() {
                        if let newValue = Current.excitations.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                            tableView.reloadData()
                        }
                    }
                case 1:
                    if Current.signals.moveLeft() {
                        if let newValue = Current.signals.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                            tableView.reloadData()
                        }
                    }
                case 2, 3, 4:
                    if Current.shifts.moveLeft() {
                        if let newValue = Current.shifts.current().value {
                            let type = Current.shifts.current().type
                            
                            switch type {
                            case .shiftInCm:
                                Current.raman.updateParameter(newValue, forDataSource: 2, inWhichTab: .spectroscopy)
                            case .shiftInGhz:
                                Current.raman.updateParameter(newValue, forDataSource: 3, inWhichTab: .spectroscopy)
                            case .shiftInMev:
                                Current.raman.updateParameter(newValue, forDataSource: 4, inWhichTab: .spectroscopy)
                            default:
                                os_log("Wrong type for shift in leading swipe action", log: Log.general, type: .error)
                            }
                            tableView.reloadData()
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in leading swipe action: %d", log: Log.general, type: .error, indexPath.row)
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
                    if Current.excitations.moveRight() {
                        if let newValue = Current.excitations.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                            tableView.reloadData()
                        }
                    }
                case 1:
                    if Current.signals.moveRight() {
                        if let newValue = Current.signals.current().value {
                            Current.raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                            tableView.reloadData()
                        }
                    }
                case 2, 3, 4:
                    if Current.shifts.moveRight() {
                        if let newValue = Current.shifts.current().value {
                            let type = Current.shifts.current().type
                            
                            switch type {
                            case .shiftInCm:
                                Current.raman.updateParameter(newValue, forDataSource: 2, inWhichTab: .spectroscopy)
                            case .shiftInGhz:
                                Current.raman.updateParameter(newValue, forDataSource: 3, inWhichTab: .spectroscopy)
                            case .shiftInMev:
                                Current.raman.updateParameter(newValue, forDataSource: 4, inWhichTab: .spectroscopy)
                            default:
                                os_log("Wrong type for shift in trainling swipe action", log: Log.general, type: .error)
                            }
                            tableView.reloadData()
                        }
                    }
                default:
                    os_log("Wrong value for indexPath.row in trailing swipe action: %d", log: Log.general, type: .error, indexPath.row)
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

