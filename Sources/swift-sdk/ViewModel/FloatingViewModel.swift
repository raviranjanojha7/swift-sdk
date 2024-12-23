//
//  File 3.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import SwiftUI

@MainActor
class FloatingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var widgetType: WidgetType = WidgetType.floating
    @Published var playlistId: String?
    @Published var playlist: PlaylistDataWithProducts?
    @Published var mediaData: [String: OverlayMedia] = [:]
    @Published var handle = ""
    @Published var isFloatingCollapsed = true
    @Published var isFloatingClosed = false
    
    // MARK: - Initialization
    init() {
        setupInitialState()
    }
    
    private func setupInitialState() {
        isLoading = false
        mediaData = [:]
        widgetType = WidgetType.floating
        handle = ""
        isFloatingCollapsed = true
        isFloatingClosed = false
    }
}

// MARK: - Helper Methods
extension FloatingViewModel {
    func updatePlaylist(_ newPlaylist: PlaylistDataWithProducts?) {
        playlist = newPlaylist
    }
    
    func updateMediaData(_ newMediaData: [String: OverlayMedia]) {
        mediaData = newMediaData
    }
    
    func toggleCollapsed() {
        isFloatingCollapsed.toggle()
    }
    
    func toggleClosed() {
        isFloatingClosed.toggle()
    }
}

// MARK: - Loading Methods
extension FloatingViewModel {
    func loadPlaylist() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Implement your playlist loading logic here
        // Example:
        guard let playlistId = playlistId else {
            throw FloatingError.missingPlaylistId
        }
        
        // Add your API call here
    }
}

// MARK: - Error Handling
enum FloatingError: Error {
    case missingPlaylistId
    case invalidPlaylist
    case networkError(Error)
    case decodingError(Error)
}
