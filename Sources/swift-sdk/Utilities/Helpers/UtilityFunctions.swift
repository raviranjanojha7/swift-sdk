//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 12/12/24.
//

import Foundation

func getUrls(files: [MediaFile], mediaId: String, cdn: String) -> MediaUrls {
    var urls: [String: String] = [:]
    
    for file in files {
        let fileExtension = ["STORY", "POSTER"].contains(file.variant.rawValue) ? "jpg" : "mp4"
        urls[file.variant.rawValue] = "https:\(cdn)/quinn_\(file.id).\(fileExtension)"
    }
    
    return MediaUrls(
        short: urls["SHORT"],
        full: urls["FULL"],
        poster: urls["POSTER"],
        story: urls["STORY"]
    )
}

func getHandleHash(handle: String, shopType: String = "SHOPIFY") async throws -> String {
    if handle.hasPrefix("/") || shopType == "GENERAL" {
        return sha256(handle)
    } else {
        return handle
    }
}



@MainActor
func shouldAddPropertiesToATC(productId: String, variantId: String) -> Bool {
    let products = ProductViewManager.shared.getProductViewed()
    if products.isEmpty { return false }
    
    let productViewed = products.first { product in
        product.productid == productId || product.variantid == variantId
    }
    
    let abTesting = Global.shared.quinn?.settings.abTesting ?? false
    let cartTracking = Global.shared.quinn?.settings.cartTracking ?? false
    
    return productViewed != nil || abTesting || cartTracking
}


