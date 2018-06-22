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
    
    var raman: Raman?
    var selectedTheme: ThemeMode?
    var themeModeButton: UIBarButtonItem!
    var memory : Memory?

    // MARK: - Outlets
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: - actions
    
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
        // display theme mode button for this mode
        guard let selectedTheme = selectedTheme else { return }
        
        UIView.transition(with: self.view, duration: 0.5, options: .beginFromCurrentState, animations: {
            
            // set navigation bar
            self.navigationController?.navigationBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Theme.color(for: .navBarTextColor, with: selectedTheme.mode)]
            
            // set tab bar
            self.tabBarController?.tabBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
            self.tabBarController?.tabBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
            if #available(iOS 10.0, *) {
                self.tabBarController?.tabBar.unselectedItemTintColor = Theme.color(for: .navBarUnselectedTextColor, with: selectedTheme.mode)
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
            self.myTableView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: selectedTheme.mode)
            
            // set the separator color to the same as the background
            self.myTableView.separatorColor = Theme.color(for: .tableViewSeparatorColor, with: selectedTheme.mode)
            
        }, completion: nil)
        
        // update the display with new them
        myTableView.reloadData()
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localize
        
        aboutButton.title = .about
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        
        // This prevents the space below the cells to have spacers
        myTableView.tableFooterView = UIView()
        
        // Remove space at top of tableview
        myTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(ViewController.themeModeButtonTapped(_:)))
        
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
                vc.memory = self.memory
            }
        }
    }
 }

// MARK: - Tableview delegates

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let raman = raman else { return }
        
        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
        
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = raman.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.myExp = Constants.specExp[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.spectroscopy
        controller.raman = raman
        controller.selectedTheme = selectedTheme
        controller.memory = memory
        controller.selectedTheme = selectedTheme
        
        navigationController!.pushViewController(controller, animated: true)
    }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ramanShift.count
    }
    
    @objc func configureCell(cell: DataCell, indexPath: IndexPath) {
        guard let raman = raman, let selectedTheme = selectedTheme else { return }
        cell.valueLabel!.text = raman.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.valueLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        cell.dataLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.unitsLabel.text = Constants.specUnits[indexPath.row]
        cell.unitsLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.exponentsLabel.text = Constants.specExp[indexPath.row]
        cell.exponentsLabel.textColor = Theme.color(for: .cellTextColor, with: selectedTheme.mode)
        cell.backgroundColor = Theme.color(for: .cellBackgroundColor, with: selectedTheme.mode)
        if selectedTheme.mode == .darkMode {
            cell.dataImageView?.image = UIImage(named: "spectro\(indexPath.row)")
        } else {
            cell.dataImageView?.image = UIImage(named: "spectro_light\(indexPath.row)")
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

@available(iOS 11.0, *)
extension ViewController {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let previous = UIContextualAction(style: .normal, title: "previous") { (action, view, completionHandler) in
            if let memory = self.memory, let raman = self.raman {
                let newValue = memory.previous(dataSource: .spectroscopy, parameter: indexPath.row)
                if newValue != 0.0 {
                    raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                    tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        if let selectedTheme = selectedTheme {
            previous.backgroundColor = Theme.color(for: .swipeActionColor, with: selectedTheme.mode)
        }
        let config = UISwipeActionsConfiguration(actions: [previous])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let next = UIContextualAction(style: .normal, title: "next") { (action, view, completionHandler) in
            if let memory = self.memory, let raman = self.raman {
                let newValue = memory.next(dataSource: .spectroscopy, parameter: indexPath.row)
                if newValue != 0.0 {
                    raman.updateParameter(newValue, forDataSource: indexPath.row, inWhichTab: .spectroscopy)
                    tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        if let selectedTheme = selectedTheme {
            next.backgroundColor = Theme.color(for: .swipeActionColor, with: selectedTheme.mode)
        }
        let config = UISwipeActionsConfiguration(actions: [next])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

