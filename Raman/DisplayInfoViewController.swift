//
//  DisplayInfoViewController.swift
//  BasicRaman
//
//  Created by Denis Ricard on 2015-05-12.
//  Copyright (c) 2015 Hexaedre. All rights reserved.
//

import UIKit
import StoreKit

class DisplayInfoViewController: UIViewController, IAPContainer {
    
    // MARK: - Properties
    
    var selectedTheme: ThemeMode?
    var memory: Memory?

    // IAP properties
    var iapHelper: IAPHelper? {
        didSet {
            updateIAPHelper()
        }
    }
    // this will be set when iapHelper is set through the updateIAPHelper function
    private var memoriesProduct: SKProduct?
    
    // MARK: - Outlets
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var madeByLabel: UILabel!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var buyMemoryLabel: UILabel!
    @IBOutlet weak var buyButtonLabel: UIButton!
    @IBOutlet weak var restoreLabel: UIButton!
    
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
        
        view.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.94, alpha:1.00)
        
        // IAP
        if let memoriesProduct = memoriesProduct, let iapHelper = iapHelper, let priceTag = iapHelper.localizedPriceString(product: memoriesProduct) {
            buyButtonLabel.setTitle(priceTag, for: .normal)
        } else {
            buyButtonLabel.setTitle("Buy", for: .normal)
        }
        buyButtonLabel.layer.borderColor = UIColor.darkGray.cgColor
        buyButtonLabel.layer.cornerRadius = 5
        buyButtonLabel.layer.borderWidth = 1
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
        let url = URL(string: "http://hexaedre.com/apps/raman/")
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

// MARK: - IAP handlers

extension DisplayInfoViewController {

    @IBAction func buyButtomPressed(_ sender: UIButton) {
        guard let memoriesProduct = memoriesProduct else { return }
        iapHelper?.buyProduct(product: memoriesProduct)
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        iapHelper?.restoreProduct()
    }
    
    @objc func handlePurchaseNotification(notification: NSNotification) {
        dump(RamanIAPHelper.memories.productId)
        if let productID = notification.object as? String, productID == RamanIAPHelper.memories.productId {
            dump(productID)
            if let memory = memory {
                memory.isPurchased = true
                memory.saveMemoryToDisk()   // save the purchased status to disk
            }
            setMemoriesPurchased(true)
        }
    }
    
    private func setMemoriesPurchased(_ purchased: Bool, animated: Bool = true) {
    }
    
    private func updateIAPHelper() {
        passIAPHelperToChildren()

        guard let iapHelper = iapHelper else { return }
        
        iapHelper.requestProducts { (products) in
            self.memoriesProduct = products!.filter{ $0.productIdentifier == RamanIAPHelper.memories.productId }.first
            if let memoriesProduct = self.memoriesProduct, let priceTag = iapHelper.localizedPriceString(product: memoriesProduct) {
                self.buyButtonLabel.setTitle(priceTag, for: .normal)
            }
        }
    }
}
