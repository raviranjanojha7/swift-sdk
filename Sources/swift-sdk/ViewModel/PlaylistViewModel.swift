//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import SwiftUI


@MainActor final class PlaylistViewModel: ObservableObject {
    @Published var playlist: PlaylistData? = nil
    @Published var isLoading = false
    
    
    func getPlaylistData() {
        print("asdasdasdasd")
        isLoading = true
        Task {
            do {
                playlist = try await NetworkManager.shared.getPlaylistData()
                print("hereee is the playlist", playlist?.media, playlist?.media.count)
            } catch {
                // Print the error
                print("Error fetching playlist data: \(error)")
                // Optionally handle the error, e.g., by setting an alert or error state
                // playlist = AlertContext.invalidResponse
            }
            isLoading = false
        }
    }
    
    
}
