//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation



struct MediaProduct: Codable, @unchecked Sendable {
    let card_top_labels: [String: Any]?
    let available: Bool
    let compare_at_price: String
    let compare_at_price_max: String
    let compare_at_price_max_number: String
    let compare_at_price_min: String
    let compare_at_price_min_number: String
    let compare_at_price_number: String
    let description: String
    let featured_image: String
    let featured_image_large: String
    let handle: String
    let id: String
    let images: [MediaProductImage]
    let options: [String]
    let options_with_values: [ProductOptionWithValues]
    let price: String
    let price_max: String
    let price_max_number: String
    let price_min: String
    let price_min_number: String
    let price_number: String
    let productmetadata: [Productmetadata]
    let quinn_description: String
    let swatches_data: [String: SwatchData]
    let swatches_data_formatted: [String: [SwatchData]]
    let title: String
    let url: String
//    let variants: [ProductVariant]
    
    enum CodingKeys: String, CodingKey {
        case available
        case card_top_labels = "card_top_labels"
        case compare_at_price = "compare_at_price"
        case compare_at_price_max = "compare_at_price_max"
        case compare_at_price_max_number = "compare_at_price_max_number"
        case compare_at_price_min = "compare_at_price_min"
        case compare_at_price_min_number = "compare_at_price_min_number"
        case compare_at_price_number = "compare_at_price_number"
        case description
        case featured_image = "featured_image"
        case featured_image_large = "featured_image_large"
        case handle, id, images, options
        case options_with_values = "options_with_values"
        case price
        case price_max = "price_max"
        case price_max_number = "price_max_number"
        case price_min = "price_min"
        case price_min_number = "price_min_number"
        case price_number = "price_number"
        case productmetadata
        case quinn_description = "quinn_description"
        case swatches_data = "swatches_data"
        case swatches_data_formatted = "swatches_data_formatted"
        case title, url, variants
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let cardTopLabelsData = try? container.decodeIfPresent(Data.self, forKey: .card_top_labels) {
            self.card_top_labels = try? JSONSerialization.jsonObject(with: cardTopLabelsData) as? [String: Any]
        } else {
            self.card_top_labels = nil
        }
        
        self.available = try container.decode(Bool.self, forKey: .available)
        self.compare_at_price = try container.decode(String.self, forKey: .compare_at_price)
        self.compare_at_price_max = try container.decode(String.self, forKey: .compare_at_price_max)
        self.compare_at_price_max_number = try container.decode(String.self, forKey: .compare_at_price_max_number)
        self.compare_at_price_min = try container.decode(String.self, forKey: .compare_at_price_min)
        self.compare_at_price_min_number = try container.decode(String.self, forKey: .compare_at_price_min_number)
        self.compare_at_price_number = try container.decode(String.self, forKey: .compare_at_price_number)
        self.description = try container.decode(String.self, forKey: .description)
        self.featured_image = try container.decode(String.self, forKey: .featured_image)
        self.featured_image_large = try container.decode(String.self, forKey: .featured_image_large)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.id = try container.decode(String.self, forKey: .id)
        self.images = try container.decode([MediaProductImage].self, forKey: .images)
        self.options = try container.decode([String].self, forKey: .options)
        self.options_with_values = try container.decode([ProductOptionWithValues].self, forKey: .options_with_values)
        self.price = try container.decode(String.self, forKey: .price)
        self.price_max = try container.decode(String.self, forKey: .price_max)
        self.price_max_number = try container.decode(String.self, forKey: .price_max_number)
        self.price_min = try container.decode(String.self, forKey: .price_min)
        self.price_min_number = try container.decode(String.self, forKey: .price_min_number)
        self.price_number = try container.decode(String.self, forKey: .price_number)
        self.productmetadata = try container.decode([Productmetadata].self, forKey: .productmetadata)
        self.quinn_description = try container.decode(String.self, forKey: .quinn_description)
        self.swatches_data = try container.decode([String: SwatchData].self, forKey: .swatches_data)
        self.swatches_data_formatted = try container.decode([String: [SwatchData]].self, forKey: .swatches_data_formatted)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
//        self.variants = try container.decode([ProductVariant].self, forKey: .variants)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(available, forKey: .available)
        
        if let cardTopLabels = card_top_labels,
           let jsonData = try? JSONSerialization.data(withJSONObject: cardTopLabels) {
            try container.encode(jsonData, forKey: .card_top_labels)
        }
        
        try container.encode(compare_at_price, forKey: .compare_at_price)
        try container.encode(compare_at_price_max, forKey: .compare_at_price_max)
        try container.encode(compare_at_price_max_number, forKey: .compare_at_price_max_number)
        try container.encode(compare_at_price_min, forKey: .compare_at_price_min)
        try container.encode(compare_at_price_min_number, forKey: .compare_at_price_min_number)
        try container.encode(compare_at_price_number, forKey: .compare_at_price_number)
        try container.encode(description, forKey: .description)
        try container.encode(featured_image, forKey: .featured_image)
        try container.encode(featured_image_large, forKey: .featured_image_large)
        try container.encode(handle, forKey: .handle)
        try container.encode(id, forKey: .id)
        try container.encode(images, forKey: .images)
        try container.encode(options, forKey: .options)
        try container.encode(options_with_values, forKey: .options_with_values)
        try container.encode(price, forKey: .price)
        try container.encode(price_max, forKey: .price_max)
        try container.encode(price_max_number, forKey: .price_max_number)
        try container.encode(price_min, forKey: .price_min)
        try container.encode(price_min_number, forKey: .price_min_number)
        try container.encode(price_number, forKey: .price_number)
        try container.encode(productmetadata, forKey: .productmetadata)
        try container.encode(quinn_description, forKey: .quinn_description)
        try container.encode(swatches_data, forKey: .swatches_data)
        try container.encode(swatches_data_formatted, forKey: .swatches_data_formatted)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
//        try container.encode(variants, forKey: .variants)
    }
}

struct ProductVariant: Codable, Sendable {
    let attribute_id: String
    let available: Bool
    let compare_at_price: String
    let compare_at_price_number: String
    let featured_image: String
    let id: String
    let option1: String
    let price: String
    let price_number: String
    let sku: String
    let title: String
    let value_index: String
    
    enum CodingKeys: String, CodingKey {
        case attribute_id = "attribute_id"
        case available
        case compare_at_price = "compare_at_price"
        case compare_at_price_number = "compare_at_price_number"
        case featured_image = "featured_image"
        case id, option1, price
        case price_number = "price_number"
        case sku, title
        case value_index = "value_index"
    }
}

struct MediaProductImage: Codable, Sendable {
    let altText: String
    let url: String
}

struct ProductOptionWithValues: Codable, Sendable {
    let id: String
    let name: String
    let values: [String]
}

struct Productmetadata: Codable, Sendable {
    let label: String
    let value: String
}

struct SwatchData: Codable, Sendable {
    let available: Bool
    let group: String
    let image: String
    let sku: String
    let swatch: String
    let value: String
    let variant_id: String
    
    enum CodingKeys: String, CodingKey {
        case available, group, image, sku, swatch, value
        case variant_id = "variant_id"
    }
}
