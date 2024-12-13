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
    let global = Global.shared
    
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
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(viewModel.playlist?.media ?? [], id: \.media?.id) { mediaItem in
                            Button(action: {
                                withAnimation {
                                    // Your commented overlay setup code
                                }
                            }) {
                                if mediaItem.type == .media {
                                    CardItemView(mediaItem: mediaItem, viewModel: viewModel)
                                        .frame(width: 151, height: 271)
                                } else if mediaItem.type == .group {
                                    // For groups, render each media in the group
                                    ForEach(mediaItem.group?.medias ?? [], id: \.id) { groupMedia in
                                        CardItemView(
                                            mediaItem: PlaylistMediaItem(
                                                type: .media,
                                                group: nil,
                                                media: groupMedia
                                            ),
                                            viewModel: viewModel
                                        )
                                        .frame(width: 151, height: 271)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
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
