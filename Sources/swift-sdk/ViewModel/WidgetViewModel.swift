//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import SwiftUI

@MainActor
class WidgetViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var widgetType: WidgetType = WidgetType.cards
    @Published var playlistId: String?
    @Published var playlist: PlaylistData?
    @Published var mediaData: [String: OverlayMediaItem] = [:]
    @Published var handle = ""
    @Published var isOverlayOpen = false
    
  
}


extension WidgetViewModel {
    func updatePlaylist(_ newPlaylist: PlaylistData?) {
        playlist = newPlaylist
    }
    
    func updateMediaData(_ newMediaData: [String: OverlayMediaItem]) {
        mediaData = newMediaData
    }
}
