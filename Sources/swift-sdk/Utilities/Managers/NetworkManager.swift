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

struct PlaylistResponse: Codable {
    let playlist: String
}
