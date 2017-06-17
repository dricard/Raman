//
//  CalculatorViewController.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-17.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var digitButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var tooltipButton: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var previousValueLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var expomentLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func digitPressed(_ sender: UIButton) {
    }
    
    @IBAction func memoryButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func enterPressed(_ sender: UIButton) {
    }
    
    @IBAction func tooltipButtonPressed(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
