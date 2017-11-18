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
    
    func restoreProduct() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductRequest delegate
extension IAPHelper: SKProductsRequestDelegate {
    
    // utility for handling localized currency
    
    func localizedPriceString(product: SKProduct) -> String? {
        let price = product.price
        let locale = product.priceLocale
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: price)
    }
    
    // call returned without error, process it
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
                // TODO: - Handle purchasing notification
                print("not handling 'purchasing' transaction state")
            case .purchased:
                completeTransaction(transaction: transaction)
            case .failed:
                failedTransaction(transaction: transaction)
            case .restored:
                completeTransaction(transaction: transaction)
            case .deferred:
                // This might happen when a child requests approval from a parent
                // to make the purchase, so it's very important not to block
                // the UI here (no modal dialog, etc.) and let the child continue
                // with the content while waiting for their parent to approve,
                // which might occur days later.
                // TODO: - Handle deferred notification
                print("not handling 'deferred' transaction state")
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        deliverPurchaseNotification(identifier: transaction.payment.productIdentifier)
        print("Received confirmation of payment")
        print("transaction ID is \(String(describing: transaction.payment.productIdentifier))")
        // THIS IS VERY IMPORTANT!!
        SKPaymentQueue.default().finishTransaction(transaction)
        deliverPurchaseNotification(identifier: transaction.payment.productIdentifier)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError.Code {
            // we log all error except if user simply cancelled
            // (and never show an error dialog for canceling, of course)
            if error != SKError.Code.paymentCancelled {
                // log error
                print("Transaction error: \(error.rawValue)")
            }
        }
        // THIS IS VERY IMPORTANT!!
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification(identifier: String?) {
        print("Sending notification")
        guard let identifier = identifier else { return }
        print("Object passed is \(identifier)")
        NotificationCenter.default.post(name: IAPHelper.iAPHelperPurchaseNotification, object: RamanIAPHelper.memories.productId)
    }
}

protocol IAPContainer {
    var iapHelper: IAPHelper? { get set }
    
    func passIAPHelperToChildren()
}

extension IAPContainer where Self : UIViewController {
    func passIAPHelperToChildren() {
        for vc in childViewControllers {
            var iapContainer = vc as? IAPContainer
            iapContainer?.iapHelper = iapHelper
        }
    }
}
