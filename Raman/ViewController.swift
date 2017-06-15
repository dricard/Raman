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
    var selectedTheme: Theme.ThemeModes?
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
        
        // set the tableview background color (behind the cells)
        myTableView.backgroundColor = Theme.color(for: .tableViewBackgroundColor, with: .darkMode)
        
        // This prevents the space below the cells to have spacers
        myTableView.tableFooterView = UIView()
        
        // set the separator color to the same as the background
        myTableView.separatorColor = Theme.color(for: .tableViewSeparatorColor, with: .darkMode)
        
        // Remove space at top of tableview
        myTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // add theme mode button to navigation bar
        
        themeModeButton = UIBarButtonItem(image: UIImage(named: "lightModeIcon"), style: .plain, target: self, action: #selector(ViewController.themeModeButtonTapped(_:)))
        
        navigationItem.leftBarButtonItem = themeModeButton
        
        updateThemeModeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // udate all data
        myTableView.reloadData()
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
        guard let raman = raman else { return }
        cell.valueLabel!.text = raman.specData(indexPath.row).format(Constants.specRounding[indexPath.row])
        cell.dataLabel?.text = Constants.ramanShift[indexPath.row]
        cell.dataImageView?.image = UIImage(named: "spectro\(indexPath.row)")
        cell.unitsLabel.text = Constants.specUnits[indexPath.row]
        cell.exponentsLabel.text = Constants.specExp[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier) as! DataCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
}
