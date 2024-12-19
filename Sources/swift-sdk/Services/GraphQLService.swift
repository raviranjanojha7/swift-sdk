//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 18/12/24.
//

import Foundation

public class GraphQLService {
    private let baseURL: URL
    private let accessToken: String
    
    init(shop: String, accessToken: String, version: String = "2024-04") {
        self.baseURL = URL(string: "https://\(shop)/api/\(version)/graphql.json")!
        self.accessToken = accessToken
    }
    
    func query<T: Decodable>(_ requestBody: GraphQLRequestBody) async throws -> T {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(accessToken, forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        return try await NetworkManager.shared.fetchData(with: request, as: T.self)
    }
}
