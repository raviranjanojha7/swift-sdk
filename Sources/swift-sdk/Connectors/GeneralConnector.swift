//
//  File 3.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation


class GeneralConnector: BaseConnector {
    let shop: String
    let accessToken: String
    
    init(shop: String, accessToken: String) {
        self.shop = shop
        self.accessToken = accessToken
    }
    
    func getPlaylistData() async throws -> PlaylistData {
        guard let url = URL(string: "https://zany-calm-energy.glitch.me/data") else {
            throw APIError.invalidURL
        }
        return try await NetworkManager.shared.fetchData(from: url, as: PlaylistData.self)
    }
    
    func getSettings() {}
    func getProductsData() {}
    func getPlaylistHandle() {}
    func getPaginatedPlaylistMetadata() {}
    func getPaginatedPlaylistMediaData() {}
    func getFilePrefix() {}
}
