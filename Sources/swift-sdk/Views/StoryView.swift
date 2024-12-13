//
//  StoryView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct StoryView: View {
    @StateObject private var viewModel: WidgetViewModel
    let playlistId: String
    let pageHandle: String
    let layer: Int
    let global = Global.shared
    
    public init(playlistId: String, pageHandle: String, layer: Int) {
        self.playlistId = playlistId
        self.pageHandle = pageHandle
        self.layer = layer
        self._viewModel = StateObject(wrappedValue: WidgetViewModel())
    }
    
    public var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(viewModel.playlist?.media ?? [], id: \.media?.id) { mediaItem in
                            Button(action: {
                                withAnimation {
                                    // Your commented overlay setup code
                                }
                            }) {
                                if mediaItem.type == .media {
                                    StoryItemView(mediaItem: mediaItem, viewModel: viewModel)
                                } else if mediaItem.type == .group {
                                    // For groups, render each media in the group
                                    ForEach(mediaItem.group?.medias ?? [], id: \.id) { groupMedia in
                                        StoryItemView(
                                            mediaItem: PlaylistMediaItem(
                                                type: .media,
                                                group: nil,
                                                media: groupMedia
                                            ),
                                            viewModel: viewModel
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
   private func loadData() async {
        print("Loading data....")
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        
        do {
            let connector = try getConnector()
            Task {
                print("Before getPlaylistData call")
                let playlist = try await connector.getPlaylistData(playlistId: playlistId)
                print("After getPlaylistData call")
                viewModel.updatePlaylist(playlist)
                print("After updating playlist")
            }
        } catch {
            print("Error loading playlist: \(error)")
        }
    }
}

// Keep the existing StoryItemView implementation unchanged
private struct StoryItemView: View {
    let mediaItem: PlaylistMediaItem
    @ObservedObject var viewModel: WidgetViewModel
    
    var body: some View {
        Button {
            print("Profile View Tapped - Debug")
            withAnimation {
//                viewModel.currentMedia = mediaItem
//                viewModel.showOverlay = true
            }
        } label: {
            ZStack {
                if let media = mediaItem.media {
                    if let storyUrl = media.urls?.story {
                        if media.files.contains(where: { $0.variant == .story && $0.mediaid.hasSuffix(".mp4") }) {
                            VideoPlayer(url: URL(string: storyUrl))
                                .aspectRatio(contentMode: .fill)
                                .allowsHitTesting(false)
                        } else {
                            AsyncImage(url: URL(string: storyUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .allowsHitTesting(false)
                                case .failure(_):
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .allowsHitTesting(false)
                                case .empty:
                                    ProgressView()
                                        .allowsHitTesting(false)
                                @unknown default:
                                    ProgressView()
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .padding(3)
            .background(
                LinearGradient(
                    colors: [.red, .orange, .yellow, .orange],
                    startPoint: .top, endPoint: .bottom
                )
                .clipShape(Circle())
            )
        }
    }
}

#Preview {
    StoryView(playlistId: "123", pageHandle: "456", layer: 7)
        .environmentObject(OverlayViewModel())
}
