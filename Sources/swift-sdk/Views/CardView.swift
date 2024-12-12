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
    let global: Global.shared
    
    public init(playlistId: String, pageHandle: String, layer: Int) {
        self.playlistId = playlistId
        self.pageHandle = pageHandle
        self.layer = layer
        _viewModel = StateObject(wrappedValue: WidgetViewModel())
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        if let firstMedia = viewModel.playlist?.media.first {
                            Button {
                                withAnimation {
                                    global.quinn.functions.setupOverlay(payload: SetupOverlay(
                                        playlist: viewModel.playlist,
                                        widgetType: .cards
                                    ))
                                    
                                    global.quinn.function.openOverlay(payload: OpenOverlayAction(
                                        activeIndex: 0,
                                        groupMediaIndex: 0
                                    ))
                                } label: {
                                    CardItemView(mediaItem: firstMedia, viewModel: viewModel)
                                        .frame(width: 151, height: 271)
                                }
                            }
                        }
                            .padding(10)
                    }
                }
            }
                .task {
                    await loadData()
                }
        }
    }
    
    private func loadData() async {
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        
        do {
            let connector = try getConnector()
            let playlist = try await connector.getPlaylistData()
            viewModel.updatePlaylist(playlist)
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
                if let videoUrl = media.urls.?short {
                    VideoPlayer(url: URL(strig: videoUrl))
                        .aspectRatio(9/16, contentMode: .fill)
                        .frame(widget: 151, height: 271)
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
            VStack {
                Spacer()
                productDetailsOverlay(media: mediaItem.media)
            }
        }
        .shadow(radius: 4)
        
    }
    
    private var productDetailsOverlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cardBundle.profileName)
                .font(.system(size: 14, weight: .semibold))
            HStack {
                Text("₹ 999")
                    .font(.system(size: 14, weight: .bold))
                Text("₹ 3,999")
                    .strikethrough()
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("75% off")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    CardView(bundles: .constant(CardAndStoryBundle(
        profileName: "Canada",
        medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
        ]
    )))
    .environmentObject(OverlayViewModel())
}
