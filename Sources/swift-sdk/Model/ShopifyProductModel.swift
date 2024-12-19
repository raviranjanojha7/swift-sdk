//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 19/12/24.
//

import Foundation

struct Price: Codable {
    let amount: String
    let currencyCode: String
}

struct PriceRange: Codable {
    let maxVariantPrice: Price?
    let minVariantPrice: Price
}

struct FeaturedImage: Codable {
    let image_large: String
    let image_small: String
}

struct ProductImage: Codable {
    let url: String
    let altText: String?
}

struct ImageNode: Codable {
    let nodes: [ProductImage]
}

struct ProductOptions: Codable {
    let id: String
    let name: String
    let values: [String]
}

struct QuinnDescription: Codable {
    let value: String
}

struct VariantSelectedOption: Codable {
    let name: String
    let value: String
}

struct Variant: Codable {
    let availableForSale: Bool
    let compareAtPrice: Price
    let currentlyNotInStock: Bool
    let id: String
    let image: ProductImage
    let price: Price
    let selectedOptions: [VariantSelectedOption]
    let sku: String
    let title: String
}

struct VariantNode: Codable {
    let nodes: [Variant]
}

struct ImageEdge: Codable {
    let node: ProductImage
}

struct ImageConnection: Codable {
    let edges: [ImageEdge]
}

public struct ShopifyProduct: Codable {
    let id: String
    let title: String
    let handle: String
    let description: String
    let priceRange: PriceRange
    let images: ImageConnection
    
    // Optional fields
    let availableForSale: Bool?
    let card_top_lebels: String?
    let compareAtPriceRange: PriceRange?
    let descriptionHtml: String?
    let featuredImage: FeaturedImage?
    let onlineStoreUrl: String?
    let options: [ProductOptions]?
    let quinn_description: QuinnDescription?
    let tags: [String]?
    let variants: VariantNode?
}

public struct ShopifyProductsResponse: Codable {
    let data: ProductDictionary
    
    public init(data: ProductDictionary) {
        self.data = data
    }
}

public struct ProductDictionary: Codable, Sequence {
    private let products: [String: ShopifyProduct]
    
    public var allProducts: [ShopifyProduct] {
        Array(products.values)
    }
    
    public func makeIterator() -> Dictionary<String, ShopifyProduct>.Iterator {
        return products.makeIterator()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.products = try container.decode([String: ShopifyProduct].self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(products)
    }
}


