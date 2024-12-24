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
        
        // Get raw data and response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("Response JSON:", jsonString)
//        }
        
        // Parse into dictionary to handle null values
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              var dataDict = json["data"] as? [String: Any] else {
            throw APIError.invalidData
        }
        
        // Filter out null values
        dataDict = dataDict.filter { $0.value is [String: Any] }
        let cleanJson = ["data": dataDict]
        
        // Re-encode the cleaned data
        let cleanData = try JSONSerialization.data(withJSONObject: cleanJson)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: cleanData)
    }
}
