//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import SwiftUI

@MainActor
class InlineViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var playlistId: String = ""
    @Published var playlist: PlaylistDataWithProducts?
    @Published var widgetType: WidgetType = WidgetType.imax
    @Published var handle = ""
    @Published var mediaData: [String: PlaylistMediaItemWithProducts] = [:]
    
    // MARK: - Initialization
    init() {
        setupInitialState()
    }
    
    private func setupInitialState() {
        isLoading = false
        handle = ""
        playlistId = ""
        mediaData = [:]
        widgetType = WidgetType.imax
    }
}

// MARK: - Helper Methods
extension InlineViewModel {
    func updatePlaylist(_ newPlaylist: PlaylistDataWithProducts?) {
        playlist = newPlaylist
    }
    
    func updateMediaData(_ newMediaData: [String: PlaylistMediaItemWithProducts]) {
        mediaData = newMediaData
    }
    
    func updateHandle(_ newHandle: String) {
        handle = newHandle
    }
    
    func updatePlaylistId(_ newPlaylistId: String) {
        playlistId = newPlaylistId
    }
}

