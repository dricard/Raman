//
//  DisplayInfoViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class DisplayInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            versionNumberLabel.text = "v. " + version
        }
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.stringFromDate(today))!
        copyrightLabel.text = "© \(year) Hexaedre"
    }
    
    // MARK: - User actions

    @IBAction func namePressed(sender: AnyObject) {
        let url = NSURL(string: "http://hexaedre.com/blog/")
//        let request = NSURLRequest(URL: url!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func logoPressed(sender: AnyObject) {
        let url = NSURL(string: "http://hexaedre.com")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func helpPressed(sender: AnyObject) {
        let url = NSURL(string: "http://hexaedre.com/Raman.html")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    @IBAction func supportPressed(sender: AnyObject) {
        let url = NSURL(string: "mailto:dr@hexaedre.com?subject=Raman%20App%20support%20request&body=Please%20ask%20your%20quetion%20or%20make%20your%20comment%20here.%20Thank%20you!")
        UIApplication.sharedApplication().openURL(url!)
    }
    
}
