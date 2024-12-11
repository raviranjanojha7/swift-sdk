//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation

protocol BaseConnector {
    func getPlaylistData() async throws -> PlaylistData
    func getSettings()
    func getProductsData()
    func getPlaylistHandle()
    func getPaginatedPlaylistMetadata()
    func getPaginatedPlaylistMediaData()
    func getFilePrefix()
}
