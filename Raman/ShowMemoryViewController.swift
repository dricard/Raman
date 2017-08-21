//
//  ShowMemoryViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-07-11.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

protocol CallMemoryDelegate: class {
    func returnedValueIs(newValue: Double)
}

class ShowMemoryViewController: UIViewController {

    // MARK: - Properties
    
    var mems: [Double]?
    var formatString: String?
    weak var delegate: CallMemoryDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memories"
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        guard let memoryList = memoryList else { return }
//        memoryLabel.text = memoryList
        
    }

    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController!) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .none
    }
    
}

extension ShowMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mems = mems else {
            return
        }
        let selectedValue = mems[indexPath.row]
        delegate?.returnedValueIs(newValue: selectedValue)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.bounds.height - 8) / 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mems = mems else { return 0 }
        return mems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoryDisplayTableViewCell", for: indexPath) as! MemoryDisplayTableViewCell
        cell.memorySlotLabel.text = "M\(indexPath.row)"
        if let mems = mems, let formatString = formatString {
            cell.memoryValueLabel.text = "\(mems[indexPath.row].format(formatString))"
        } else {
            cell.memoryValueLabel.text = "no value"

        }
        return cell
    }

}
