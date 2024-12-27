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
                    ForEach(Array(media.enumerated()), id: \.offset) { index, mediaItem in
                        storyContent(for: mediaItem, mediaIndex: index)
                            .id("\(mediaItem.media?.id ?? "")-\(index)")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    private func storyContent(for mediaItem: PlaylistMediaItemWithProducts, mediaIndex: Int) -> some View {
        Group {
            if mediaItem.type == .media {
                StoryItemView(mediaItem: mediaItem, mediaIndex: mediaIndex , viewModel: viewModel)
            } else if mediaItem.type == .group {
                groupContent(for: mediaItem, mediaIndex: mediaIndex)
            }
        }
    }
    
    private func groupContent(for mediaItem: PlaylistMediaItemWithProducts, mediaIndex: Int) -> some View {
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
    let mediaItem: PlaylistMediaItemWithProducts
    let mediaIndex: Int;
    @ObservedObject var viewModel: WidgetViewModel
    @ObservedObject private var global = Global.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                print("Story View Tapped - Debug", mediaIndex)
                withAnimation {
                    let newOverlayState = OverlayState(
                        activeIndex: mediaIndex,
                        playlist: viewModel.playlist,
                        widgetType: .story,  
                        handle: ""
                    )
                    if let quinn = global.quinn {
                        var updatedQuinn = quinn
                        updatedQuinn.overlayState = newOverlayState
                        global.quinn = updatedQuinn
                    }
                }
            } label: {
                ZStack {
                    if let media = mediaItem.media {
                        if let storyUrl = media.urls?.story {
                            if media.files.contains(where: { $0.variant == .story && storyUrl.hasSuffix(".mp4") }) {
                                VideoPlayer(url: URL(string: storyUrl), isMuted: .constant(true))
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
            
            if let media = mediaItem.media,
               let product = media.products.first {
                Text(product.title.split(separator: "|").first?.trimmingCharacters(in: .whitespaces) ?? product.title)
                    .font(.system(size: 10))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    QuinnRoot(
        sft: "44a96721cac4ae4138b4e3598cfdea12",
        cdn: "//cdn.shopify.com/s/files/1/0057/8938/4802/files/",
        shopDomain: "boatlifestylein.myshopify.com",
        shopType: .shopify
    ) {
        StoryView(
            playlistId: "INDEX_index_STORY_1",
            pageHandle: "your_page_handle",
            layer: 1
        )
    }
}


