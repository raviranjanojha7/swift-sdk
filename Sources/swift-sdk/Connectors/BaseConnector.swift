//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation

protocol BaseConnector {
    func getPlaylistData(playlistId: String) async throws -> PlaylistData
    func getSettings()
    func getProductsData(productIds: [String]) async throws -> ShopifyProductsResponse
    func getPlaylistHandle()
    func getPaginatedPlaylistMetadata()
    func getPaginatedPlaylistMediaData()
    func getFilePrefix()
}
