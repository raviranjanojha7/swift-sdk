//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 05/12/24.
//

import SwiftUI
import AVKit

public struct CardView: View {
    @StateObject private var viewModel: WidgetViewModel
    let playlistId: String
    let pageHandle: String
    let layer: Int
    @ObservedObject private var global = Global.shared
    
    public init(playlistId: String, pageHandle: String, layer: Int) {
        self.playlistId = playlistId
        self.pageHandle = pageHandle
        self.layer = layer
        _viewModel = StateObject(wrappedValue: WidgetViewModel())
    }
    
    public var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                cardScrollView
            }
        }
        .task {
            await loadData()
        }
    }
    
    private var cardScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                if let media = viewModel.playlist?.media {
                    ForEach(Array(media.enumerated()), id: \.element) { index, mediaItem in
                        cardButton(for: mediaItem, mediaIndex: index)
                            .id("\(mediaItem.media?.id ?? "")-\(index)")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func cardButton(for mediaItem: PlaylistMediaItem, mediaIndex: Int) -> some View {
        Button(action: {
            handleCardTap(index: mediaIndex)
        }) {
            cardContent(for: mediaItem)
        }
    }
    
    private func cardContent(for mediaItem: PlaylistMediaItem) -> some View {
        Group {
            if mediaItem.type == .media {
                CardItemView(mediaItem: mediaItem, viewModel: viewModel)
                    .frame(width: 151, height: 271)
            } else if mediaItem.type == .group {
                groupContent(for: mediaItem)
            }
        }
    }
    
    private func groupContent(for mediaItem: PlaylistMediaItem) -> some View {
        CardItemView(
            mediaItem: PlaylistMediaItem(
                type: .media,
                group: nil,
                media: mediaItem.group?.medias[0]
            ),
            viewModel: viewModel
        )
        .frame(width: 151, height: 271)
    }
    
    private func handleCardTap(index: Int) {
        withAnimation {
//            print("Card clicked")
            let newOverlayState = OverlayState(
                activeIndex: index,
                playlist: viewModel.playlist,
                widgetType: .cards,
                handle: ""
            )
            global.quinn.overlayState = newOverlayState
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

// Separate view for individual card items
private struct CardItemView: View {
    let mediaItem: PlaylistMediaItem
    @ObservedObject var viewModel: WidgetViewModel
    
    var body: some View {
        ZStack {
            if let media = mediaItem.media {
                if let videoUrl = media.urls?.short {
                    VideoPlayer(url: URL(string: videoUrl))
                        .aspectRatio(9/16, contentMode: .fill)
                        .frame(width: 151, height: 271)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .allowsHitTesting(false)
                }  else if let posterUrl = media.urls?.poster {
                    AsyncImage(url: URL(string: posterUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(9/16, contentMode: .fill)
                                .allowsHitTesting(false)
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .allowsHitTesting(false)
                        case .empty:
                            ProgressView()
                                .allowsHitTesting(false)
                        @unknown default:
                            ProgressView()
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(width: 151, height: 271)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .shadow(radius: 4)
        
    }
}

#Preview {
    CardView(playlistId: "playlistid", pageHandle: "pagehandle", layer: 1)
        .environmentObject(OverlayViewModel())
}
