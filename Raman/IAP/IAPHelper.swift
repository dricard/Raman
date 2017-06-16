//
//  IAPHelper.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-16.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import StoreKit
import Foundation

class IAPHelper: NSObject {
    
    // MARK: - Properties
    
    typealias ProductsRequestCompletionHandler = (_ products: [SKProduct]?) -> ()
    
    private let productIdentifiers: Set<String>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    init(prodIds: Set<String>) {
        productIdentifiers = prodIds
        super.init()
    }
}

extension IAPHelper {
    
    func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        // cancel any previously called request
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

}

extension IAPHelper: SKProductsRequestDelegate {
    // call returned without error, process result it
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // pass the response to completion handler
        productsRequestCompletionHandler?(response.products)
        // then reset state
        productsRequestCompletionHandler = .none
        productsRequest = .none
    }
    
    // call returned with an error, handle it
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product request returned with error: \(error.localizedDescription)")
        // pass a .none response to completion handler
        productsRequestCompletionHandler?(.none)
        // then reset state
        productsRequestCompletionHandler = .none
        productsRequest = .none
        
    }
}
