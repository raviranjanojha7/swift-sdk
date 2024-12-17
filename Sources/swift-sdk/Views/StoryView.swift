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
    @ObservedObject private var global = Global.shared
    
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
                storyScrollView
            }
        }
        .task {
            await loadData()
        }
    }
    
    private var storyScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                if let media = viewModel.playlist?.media {
                    ForEach(Array(media.enumerated()), id: \.element) { index, mediaItem in
                        storyContent(for: mediaItem, mediaIndex: index)
                            .id("\(mediaItem.media?.id ?? "")-\(index)")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    private func storyContent(for mediaItem: PlaylistMediaItem, mediaIndex: Int) -> some View {
        Group {
            if mediaItem.type == .media {
                StoryItemView(mediaItem: mediaItem, mediaIndex: mediaIndex , viewModel: viewModel)
            } else if mediaItem.type == .group {
                groupContent(for: mediaItem, mediaIndex: mediaIndex)
            }
        }
    }
    
    private func groupContent(for mediaItem: PlaylistMediaItem, mediaIndex: Int) -> some View {
        StoryItemView(
            mediaItem: PlaylistMediaItem(
                type: .media,
                group: nil,
                media: mediaItem.group?.medias[0]
            ),
            mediaIndex: mediaIndex,
            viewModel: viewModel
        )
    }
    
    private func loadData() async {
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        
        do {
            let connector = try getConnector()
            Task {
                let playlist = try await connector.getPlaylistData(playlistId: playlistId)
                viewModel.updatePlaylist(playlist)
            }
        } catch {
            print("Error loading playlist: \(error)")
        }
    }
}




// Keep the existing StoryItemView implementation unchanged
private struct StoryItemView: View {
    let mediaItem: PlaylistMediaItem
    let mediaIndex: Int;
    @ObservedObject var viewModel: WidgetViewModel
    @ObservedObject private var global = Global.shared
    
    
    var body: some View {
        Button {
            print("Profile View Tapped - Debug", mediaIndex)
            withAnimation {
                let newOverlayState = OverlayState(
                    activeIndex: mediaIndex,
                    playlist: viewModel.playlist,
                    widgetType: .story,  
                    handle: ""
                )
                global.quinn.overlayState = newOverlayState
            }
        } label: {
            ZStack {
                if let media = mediaItem.media {
                    if let storyUrl = media.urls?.story {
                        if media.files.contains(where: { $0.variant == .story && storyUrl.hasSuffix(".mp4") }) {
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


