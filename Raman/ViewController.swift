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
    
    @objc var valueDidChangeFromEdit = false
    @objc var whichSectionValueChanged : Int = 0
    @objc var whichDataValueChanged : Int = 0
    @objc var newValueForChangedData : Double = 0.0
    
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
        
        // set navigation bar
        navigationController?.navigationBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        navigationController?.navigationBar.tintColor = Theme.color(for: .navBarTextColor, with: selectedTheme.mode)
        
        // set tab bar
        tabBarController?.tabBar.barTintColor = Theme.color(for: .navBarTintColor, with: selectedTheme.mode)
        
        // update theme mode switch button
        switch selectedTheme.mode {
        case .darkMode:
            themeModeButton.image = UIImage(named: "lightModeIcon")
        case .lightMode:
            themeModeButton.image = UIImage(named: "darkModeIcon")
        }
        
        // set the tableview background color (behind the cells)
        myTableView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: selectedTheme.mode)
        
        // set the separator color to the same as the background
        myTableView.separatorColor = Theme.color(for: .tableViewSeparatorColor, with: selectedTheme.mode)
        
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
        guard let navController = segue.destination as? UINavigationController, let vc = navController.topViewController as? DisplayInfoViewController else { return }
        vc.selectedTheme = selectedTheme
    }
}

// MARK: - Tableview delegates

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let raman = raman else { return }
        
        /* Push the ChangeValueViewController */
        let controller = storyboard!.instantiateViewController(withIdentifier: "ChangeValueViewController") as! ChangeValueViewController
        
        
        controller.selectedDataSource = indexPath.row
        controller.selectedValue = raman.specData(indexPath.row)
        controller.myUnits = Constants.specUnits[indexPath.row]
        controller.myExp = Constants.specExp[indexPath.row]
        controller.toolTipString = Constants.specToolTip[indexPath.row]
        controller.whichTab = Raman.DataSourceType.spectroscopy
        controller.raman = raman
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
    
}
