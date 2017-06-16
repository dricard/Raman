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
    
    static let iAPHelperPurchaseNotification = NSNotification.Name.init("iAPHelperPurchaseNotification")
    
    typealias ProductsRequestCompletionHandler = (_ products: [SKProduct]?) -> ()
    
    private let productIdentifiers: Set<String>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    init(prodIds: Set<String>) {
        productIdentifiers = prodIds
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - API
extension IAPHelper {
    
    func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        // cancel any previously called request
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

// MARK: - SKProductRequest delegate
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

extension IAPHelper: SKPaymentTransactionObserver {
    
    @available(iOS 3.0, *)
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("not handling 'purchasing' transaction state")
            case .purchased:
                completeTransaction(transaction: transaction)
            case .failed:
                failedTransaction(transaction: transaction)
            case .restored:
                print("not handling 'restored' transaction state")
            case .deferred:
                print("not handling 'deferred' transaction state")
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        deliverPurchaseNotification(identifier: transaction.payment.productIdentifier)
        // THIS IS VERY IMPORTANT!!
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKErrorCode {
            // we log all error except if user simply cancelled
            if error != SKErrorCode.paymentCancelled {
                // log error
                print("Transaction error: \(error.rawValue)")
            }
        }
        // THIS IS VERY IMPORTANT!!
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification(identifier: String?) {
        guard let identifier = identifier else { return }
        NotificationCenter.default.post(name: IAPHelper.iAPHelperPurchaseNotification, object: identifier)
    }
}
