//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation
import UIKit



final class NetworkManager: Sendable {
    static let shared = NetworkManager()

    private init() {}
    
    func fetchData<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let responseString = String(data: data, encoding: .utf8) {
//            print("Response in manager", responseString)
        }
        return try handleResponse(data: data, response: response, as: type)
    }
    
    func fetchData<T: Decodable>(with request: URLRequest, as type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
         if let responseString = String(data: data, encoding: .utf8) {
//            print("Response in manager", responseString)
        }
        
        return try handleResponse(data: data, response: response, as: type)
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse, as type: T.Type) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            throw APIError.invalidData
        }
    }
}


enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case cannotParse
}

