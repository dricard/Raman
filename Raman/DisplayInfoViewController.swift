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
    
    var selectedTheme: ThemeMode?

    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var madeByLabel: UILabel!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .aboutRaman
        madeByLabel.text = .madeBy
        ideaLabel.text = .ideaBy
        thanksLabel.text = .thanksTo
        helpButton.setTitle(.helpButton, for: .normal)
        supportButton.setTitle(.supportButton, for: .normal)
        doneButton.title = .doneButton

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionNumberLabel.text = "v. " + version
        }
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"
    }
    
    // MARK: - User actions

    @IBAction func namePressed(_ sender: AnyObject) {
        let url = URL(string: "http://hexaedre.com/blog/")
//        let request = NSURLRequest(URL: url!)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func logoPressed(_ sender: AnyObject) {
        let url = URL(string: "http://hexaedre.com")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func helpPressed(_ sender: AnyObject) {
        let url = URL(string: "http://hexaedre.com/Raman.html")
        UIApplication.shared.openURL(url!)
    }
    
    
    @IBAction func supportPressed(_ sender: AnyObject) {
        let url = URL(string: "mailto:dr@hexaedre.com?subject=Raman%20App%20support%20request&body=Please%20ask%20your%20quetion%20or%20make%20your%20comment%20here.%20Thank%20you!")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func userPressedDone(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
