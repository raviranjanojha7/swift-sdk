//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 30/12/24.
//

import Foundation

@MainActor
class ProductViewManager {
    static let shared = ProductViewManager()
    private let storageKey = "_quinn-products-viewed"
    private var productViewed: [ViewedProduct] = []
    
    private init() {
        initProductViewed()
    }
    
    struct ViewedProduct: Codable, Sendable {
        let productid: String
        let producttitle: String
        let variantid: String
        let timestamp: TimeInterval
    }
    
    private func initProductViewed() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let products = try? JSONDecoder().decode([ViewedProduct].self, from: data) {
            self.productViewed = products
        }
    }
    
    func getProductViewed() -> [ViewedProduct] {
        return productViewed
    }
    
    func setProductViewed(_ products: [ViewedProduct]) {
        self.productViewed = products
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
