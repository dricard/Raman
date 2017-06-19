//
//  TooltipPopoverViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-18.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class TooltipPopoverViewController: UIViewController {
    
    var tooltipText : String?
    
    @IBOutlet weak var tooltipLabel: UILabel!
    
    override func viewDidLoad() {
        if let tooltipText = tooltipText {
            tooltipLabel.text = tooltipText
        }
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController!) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .none
    }
    
}
