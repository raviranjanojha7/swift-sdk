//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 18/12/24.
//

import Foundation

public struct GraphQLRequestBody: Codable {
    let query: String
    let variables: [String: Any]
    
    public init(query: String, variables: [String: Any]) {
        self.query = query
        self.variables = variables
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case variables
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        
        // Convert variables dictionary to JSON string
        let jsonData = try JSONSerialization.data(withJSONObject: variables)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
        try container.encode(jsonString, forKey: .variables)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decode(String.self, forKey: .query)
        
        let variablesString = try container.decode(String.self, forKey: .variables)
        if let data = variablesString.data(using: .utf8),
           let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            variables = jsonObject
        } else {
            variables = [:]
        }
    }
}

public struct GraphQLResponseBody: Codable {
    public let data: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public init(data: [String: Any]) {
        self.data = data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
        try container.encode(jsonString, forKey: .data)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let jsonData = try container.decode(String.self, forKey: .data)
        
        if let data = jsonData.data(using: .utf8),
           let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            self.data = jsonObject
        } else {
            self.data = [:]
        }
    }
}

public struct MetaObjectResponse: Codable {
    public let data: MetaObjectData
}

public struct MetaObjectData: Codable {
    public let metaobject: MetaObject
}

public struct MetaObject: Codable {
    public let fields: [Field]
}

public struct Field: Codable {
    public let key: String
    public let value: String?
}

public struct ShopifyProductsResponse: Codable {
    public let data: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public init(data: [String: Any]) {
        self.data = data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
        try container.encode(jsonString, forKey: .data)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let jsonData = try container.decode(String.self, forKey: .data)
        
        if let data = jsonData.data(using: .utf8),
           let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            self.data = jsonObject
        } else {
            self.data = [:]
        }
    }
}
