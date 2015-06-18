//
//  DisplayInfoViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit

class DisplayInfoViewController: UIViewController {

    @IBAction func namePressed(sender: AnyObject) {
        let url = NSURL(string: "https://about.me/dricard")
//        let request = NSURLRequest(URL: url!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func photonPressed(sender: AnyObject) {
        let url = NSURL(string: "http://www.photonetc.com/raman-imaging")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
