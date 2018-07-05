//
//  DisplayInfoViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class DisplayInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var Current: Environment?
    
    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var madeByLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var hexaedreLabel: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .aboutRaman
        madeByLabel.text = .madeBy
        helpButton.setTitle(.helpButton, for: .normal)
        supportButton.setTitle(.supportButton, for: .normal)
        doneButton.title = .doneButton
        atLabel.text = .atLabel
        
        if let Current = Current {
            versionNumberLabel.text = "v. " + Current.version.release + " (" + Current.version.build + ")"
        }
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"
        
        view.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
        
     }
    
    // MARK: - User actions

    @IBAction func namePressed(_ sender: AnyObject) {
        if let url = URL(string: "http://hexaedre.com/blog/")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func logoPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://hexaedre.com")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func helpPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://hexaedre.com/apps/raman/")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func supportPressed(_ sender: AnyObject) {
        if let url = URL(string: "mailto:dr@hexaedre.com?subject=Raman%20App%20support%20request&body=Please%20ask%20your%20quetion%20or%20make%20your%20comment%20here.%20Thank%20you!")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func userPressedDone(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
