//
//  ShowMemoryViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-07-11.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class ShowMemoryViewController: UIViewController {

    // MARK: - Properties
    
    var memoryList: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var memoryLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memories"
        
        guard let memoryList = memoryList else { return }
        memoryLabel.text = memoryList
        
    }

    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController!) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .none
    }

}
