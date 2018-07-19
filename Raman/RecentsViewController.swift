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
    var currentTab: Raman.DataSourceType?
    
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
        
        // Add gesture recognizer to enable moving row with a long press
        let longPress = UIGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        tableView.addGestureRecognizer(longPress)
        
        tableView.reloadData()
    }
    
    
    struct TheCell {
        static var snapShot : UIView? = nil
    }
    struct Initial {
        static var indexPath : IndexPath? = nil
    }
    
    @IBAction func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        
        os_log("longpressed", log: Log.general, type: .info)
        switch sender.state {
        case .began:
            let location = sender.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: location) else { return }
            os_log("long press began with row %d", log: Log.general, type: .info, indexPath.row)
            Initial.indexPath = indexPath
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.setSelected(false, animated: false)
                cell.setHighlighted(false, animated: false)
                
                // make an image from the pressed cell
                UIGraphicsBeginImageContext(cell.bounds.size)
                cell.layer.render(in: UIGraphicsGetCurrentContext()!)
                let cellImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // create the imageview that will be dragged
                if TheCell.snapShot == nil {
                    TheCell.snapShot = UIImageView(image: cellImage)
                    if let cellRect = tableView.cellForRow(at: indexPath) {
                        TheCell.snapShot!.frame = TheCell.snapShot!.bounds.offsetBy(dx: cellRect.frame.origin.x , dy: cellRect.frame.origin.y)
                        
                        // add dropshadow and lower opacity
                        TheCell.snapShot!.layer.masksToBounds = false
                        TheCell.snapShot!.layer.shadowColor = UIColor.black.cgColor
                        TheCell.snapShot!.layer.shadowOffset = CGSize(width: 0, height: 0)
                        TheCell.snapShot!.layer.shadowRadius = 4.0
                        TheCell.snapShot!.layer.shadowOpacity = 0.7
                        TheCell.snapShot!.layer.opacity = 1.0
                        
                        var center = cell.center
                        TheCell.snapShot!.center = center
                        TheCell.snapShot!.alpha = 0.0
                        
                        tableView.addSubview(TheCell.snapShot!)

                        // zoom image toward user
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            center.y = location.y
                            TheCell.snapShot!.center = center
                            TheCell.snapShot!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                            TheCell.snapShot!.alpha = 0.98
                            cell.alpha = 0.0
                        }, completion: { finshied in
                            // hide the cell while we're dragging its image around
                            cell.isHidden = true
                        })
                    }
                }
                // set current location to initial location
                Initial.indexPath = indexPath
                
                // enable scrolling for cell
                
            }
        case .changed:
            if TheCell.snapShot != nil {
                var center = TheCell.snapShot!.center
                let location = sender.location(in: tableView)
                guard let indexPath = tableView.indexPathForRow(at: location), let recents = recents else { return }
                print(indexPath.row)
                center.y = location.y
                if Initial.indexPath != nil && indexPath != Initial.indexPath {
                    let spotA = Spot(value: recents.stack[indexPath.row].value, type: recents.stack[indexPath.row].type)
                    let spotB = Spot(value: recents.stack[Initial.indexPath!.row].value, type: recents.stack[Initial.indexPath!.row].type)
                    recents.stack[indexPath.row] = spotB
                    recents.stack[Initial.indexPath!.row] = spotA
//                    swap(&recents.stack[indexPath.row], &recents.stack[Initial.indexPath!.row])
                    tableView.moveRow(at: Initial.indexPath!, to: indexPath)
                    Initial.indexPath = indexPath
                }
            }
        default:
            if let cell = tableView.cellForRow(at: Initial.indexPath!) {
                cell.isHidden = false
                cell.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    TheCell.snapShot!.center = cell.center
                    TheCell.snapShot!.transform = CGAffineTransform.identity
                    TheCell.snapShot!.alpha = 0.0
                    cell.alpha = 1.0
                }, completion: { (finished) in
                    Initial.indexPath = nil
                    TheCell.snapShot!.removeFromSuperview()
                    TheCell.snapShot = nil
                    })
            }
            
        }
    }
}

extension RecentsViewController: UITableViewDataSource {
    
    func configureCell(cell: RecentsTableViewCell) {
        guard let Current = Current else { return }
        
        cell.valueLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")
        cell.unitsLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")
        cell.exponentLabel.textColor = UIColor(named: "\(Current.selectedTheme.prefix())cellTextColor\(Current.colorSet.suffix())")
        cell.backgroundColor = UIColor(named: "\(Current.selectedTheme.prefix())cellBackgroundColor\(Current.colorSet.suffix())")
        
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

extension RecentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let Current = Current, let recents = recents, let value = recents.valueFor(indexPath.row), let recentsTitle = recentsTitle, let currentTab = currentTab else { return }
        // update the current position in recents stack
        recents.setCurrent(to: indexPath.row)
        let type = recents.typeFor(indexPath.row)
        
        switch recentsTitle {
        case "Excitations":
            Current.raman.updateParameter(value, forDataSource: Constants.excitationIndex, inWhichTab: .spectroscopy)
        case "Signals":
            switch currentTab {
            case .spectroscopy:
                Current.raman.updateParameter(value, forDataSource: Constants.signalIndex, inWhichTab: .spectroscopy)
            case .bandwidth:
                Current.raman.updateParameter(value, forDataSource: Constants.bwExcitationIndex, inWhichTab: .bandwidth)
            }
        case "Shifts":
            switch type {
            case .shiftInCm:
                Current.raman.updateParameter(value, forDataSource: Constants.shiftCmIndex, inWhichTab: .spectroscopy)
            case .shiftInGhz:
                Current.raman.updateParameter(value, forDataSource: Constants.shiftGhzIndex, inWhichTab: .spectroscopy)
            case .shiftInMev:
                Current.raman.updateParameter(value, forDataSource: Constants.shiftmeVIndex, inWhichTab: .spectroscopy)
            default:
                os_log("Wrong parameter in didSelectRowAt in RecentsVC: %s", log: Log.general, type: .error, recentsTitle)
            }
        case "Bandwidths":
            switch type {
            case .bandwidthInCm:
                Current.raman.updateParameter(value, forDataSource: Constants.bwCmIndex, inWhichTab: .bandwidth)
            case .bandwidthInGhz:
                Current.raman.updateParameter(value, forDataSource: Constants.bwGhzIndex, inWhichTab: .bandwidth)
            case .bandwidthInNm:
                Current.raman.updateParameter(value, forDataSource: Constants.bwNmIndex, inWhichTab: .bandwidth)
            default:
                os_log("Wrong parameter in didSelectRowAt in RecentsVC: %s", log: Log.general, type: .error, recentsTitle)
            }
            
        default:
            os_log("Wrong parameter in didSelectRowAt in RecentsVC: %s", log: Log.general, type: .error, recentsTitle)
        }
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            if let recents = recents {
                recents.stack.remove(at: indexPath.row)
                var spot: Spot
                switch recentsTitle {
                case "Excitations":
                    spot = Spot(value: nil, type: .wavelength)
                case "Signals":
                    spot = Spot(value: nil, type: .wavelength)
                case "Shifts":
                    spot = Spot(value: nil, type: .shiftInCm)
                default:
                    spot = Spot(value: nil, type: .bandwidthInCm)
                }
                recents.stack.append(spot)
                tableView.reloadData()
            }
        }
    }
    

}
