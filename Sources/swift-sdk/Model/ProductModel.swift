//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation


struct ProductData {}

struct MediaProduct: Codable, Identifiable {
    let id: String
    let title: String
    let available: Bool
    let compareAtPrice: String
    let compareAtPriceNumber: String
    let featuredImage: String
    let handle: String
    let price: String
    let priceNumber: String
    let url: String
    let variants: [Variant]?
    let provider: String?
    let vendor: String?
    let description: String?
    let quinnDescription: String?
    let images: [MediaProductImage]?
    let options: [String]?
    let optionsWithValues: [ProductOptionWithValues]?
    let swatchKey: String?
    let swatchesData: [String: SwatchData]?
    let reviews: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, available
        case compareAtPrice = "compare_at_price"
        case compareAtPriceNumber = "compare_at_price_number"
        case featuredImage = "featured_image"
        case handle, price
        case priceNumber = "price_number"
        case url, variants, provider, vendor, description
        case quinnDescription = "quinn_description"
        case images, options
        case optionsWithValues = "options_with_values"
        case swatchKey = "swatch_key"
        case swatchesData = "swatches_data"
        case reviews
    }
}

struct Variant: Codable, Identifiable {
    let id: String
    let available: Bool
    let title: String
    let compareAtPrice: String?
    let compareAtPriceNumber: String?
    let quinnDescription: String?
    let url: String?
    let featuredImage: String
    let price: String
    let priceNumber: String
    let option1: String?
    let option2: String?
    let option3: String?
    let option4: String?
    let sku: String
    let urls: MediaUrls?
    let group: VariantGroup?
    
    enum CodingKeys: String, CodingKey {
        case id, available, title
        case compareAtPrice = "compare_at_price"
        case compareAtPriceNumber = "compare_at_price_number"
        case quinnDescription = "quinn_description"
        case url
        case featuredImage = "featured_image"
        case price
        case priceNumber = "price_number"
        case option1, option2, option3, option4
        case sku, urls, group
    }
}

struct VariantGroup: Codable {
    let value: String
}

struct MediaProductImage: Codable {
    let id: String?
    let url: String
    let altText: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case altText = "altText"
    }
}

struct ProductOptionWithValues: Codable {
    let name: String
    let values: [String]
    let id: String?
}

struct SwatchData: Codable {
    let image: String
    let swatch: String
    let variantId: String
    let value: String
    let available: Bool
    let group: String?
    let sku: String
    
    enum CodingKeys: String, CodingKey {
        case image, swatch
        case variantId = "variant_id"
        case value, available, group, sku
    }
}
