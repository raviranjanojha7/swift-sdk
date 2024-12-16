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
                ForEach(viewModel.playlist?.media ?? [], id: \.media?.id) { mediaItem in
                    storyButton(for: mediaItem)
                }
            }
        }
    }
    
    private func storyButton(for mediaItem: PlaylistMediaItem) -> some View {
        Button(action: {
            withAnimation {
            }
        }) {
            storyContent(for: mediaItem)
        }
    }
    
    private func storyContent(for mediaItem: PlaylistMediaItem) -> some View {
        Group {
            if mediaItem.type == .media {
                StoryItemView(mediaItem: mediaItem, viewModel: viewModel)
            } else if mediaItem.type == .group {
                groupContent(for: mediaItem)
            }
        }
    }
    
    private func groupContent(for mediaItem: PlaylistMediaItem) -> some View {
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
    @ObservedObject var viewModel: WidgetViewModel
    @ObservedObject private var global = Global.shared
    
    
    var body: some View {
        Button {
            print("Profile View Tapped - Debug")
            withAnimation {
                let newOverlayState = OverlayState(
                    activeIndex: 0,
                    playlist: viewModel.playlist,
                    widgetType: .cards,  // or .story depending on the view
                    handle: ""
                )
                global.quinn.overlayState = newOverlayState
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
