//
//  StorefrontProduct.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//


struct StorefrontProduct: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let handle: String
    let priceRange: PriceRange
    let compareAtPriceRange: PriceRange
    let featuredImage: StorefrontImage
    let options: [ProductOption]
    let tags: [String]
    let variants: StorefrontVariants
    let images: StorefrontImages
    let availableForSale: Bool
    let onlineStoreUrl: String?
    let meta: [String: String]?
    
    struct PriceRange: Codable {
        let maxVariantPrice: Money
        let minVariantPrice: Money
    }
    
    struct Money: Codable {
        let amount: Double
        let currencyCode: String
    }
    
    struct StorefrontImage: Codable {
        let imageSmall: String?
        let imageLarge: String?
        
        enum CodingKeys: String, CodingKey {
            case imageSmall = "image_small"
            case imageLarge = "image_large"
        }
    }
    
    struct ProductOption: Codable, Identifiable {
        let id: String
        let values: [String]
        let name: String
    }
    
    struct StorefrontVariants: Codable {
        let nodes: [StorefrontVariant]
    }
    
    struct StorefrontVariant: Codable, Identifiable {
        let id: String
        let image: VariantImage
        let selectedOptions: [SelectedOption]
        let sku: String
        let title: String
        let price: Money
        let compareAtPrice: Money
        let currentlyNotInStock: Bool
        let availableForSale: Bool
    }
    
    struct VariantImage: Codable {
        let url: String
    }
    
    struct SelectedOption: Codable {
        let name: String
        let value: String
    }
    
    struct StorefrontImages: Codable {
        let nodes: [StorefrontImageNode]
    }
    
    struct StorefrontImageNode: Codable {
        let url: String
        let altText: String?
    }
}
