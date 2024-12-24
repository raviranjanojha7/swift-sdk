//
//  OverlayCardView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct OverlayCardView: View {
    let mediaItem: PlaylistMediaItemWithProducts
    let index: Int
    @ObservedObject var viewModel: OverlayViewModel
    @State private var videoProgress: CGFloat? = 0
    @State private var isMuted: Bool = false
    @ObservedObject private var global = Global.shared
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                // Content
                ZStack(alignment: .top) {
                    if mediaItem.type == .media {
                        if let media = mediaItem.media {
                            singleMediaContent(media: media, proxy: proxy)
                        }
                    } else if mediaItem.type == .group {
                        if let group = mediaItem.group {
                            let currentMedia = group.medias[viewModel.groupMediaIndex]
                            singleMediaContent(media: currentMedia, proxy: proxy)
                        }
                    }
                    
                    // Navigation overlay (behind other overlays)
                    HStack {
                        // Left tap area
                        Rectangle()
                            .fill(.black.opacity(0.01))
                            .onTapGesture {
                                updateOverlay(forward: false)
                            }
                        
                        // Right tap area
                        Rectangle()
                            .fill(.black.opacity(0.01))
                            .onTapGesture {
                                updateOverlay(forward: true)
                            }
                    }
                    
                    // Top overlay elements (only close button)
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                if let quinn = global.quinn {
                                    var updatedQuinn = quinn
                                    updatedQuinn.overlayState = nil
                                    global.quinn = updatedQuinn
                                }
                            } label: {
                                XDismissButton()
                            }
                        }
                        .padding(.top, 38)
                        .padding(.horizontal, 8)
                        
                        Spacer()
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .background(.black)
                
                // Bottom section with mute button and product info
                VStack(spacing: 16) {
                    // Mute button aligned to right
                    HStack {
                        Spacer()
                        Button {
                            isMuted.toggle()
                        } label: {
                            MuteButton(isMuted: $isMuted)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Product Information
                    let products = getAllProducts()
                    if !products.isEmpty {
                        GeometryReader { geometry in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(products, id: \.id) { product in
                                        OverlayProductInformation(product: product)
                                            .frame(width: geometry.size.width * 0.95)
                                    }
                                }
                                .padding(.horizontal, products.count > 1 ? 0 : geometry.size.width * 0.025) // Center single product
                            }
                        }
                        .frame(height: 100)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func singleMediaContent(media: PlaylistMedia<MediaProduct>, proxy: GeometryProxy) -> some View {
        if let videoUrl = media.urls?.full {
            VideoPlayer(url: URL(string: videoUrl), progress: $videoProgress)
                .aspectRatio(9/16, contentMode: .fit)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .id("video-\(videoUrl)")
        } else if let posterUrl = media.urls?.poster {
            AsyncImage(url: URL(string: posterUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
        }
    }
    
    private func updateOverlay(forward: Bool = true) {
        if mediaItem.type == .group,
           let group = mediaItem.group {
            // Handle navigation within a group
            if forward {
                if viewModel.groupMediaIndex < group.medias.count - 1 {
                    viewModel.groupMediaIndex += 1
                } else {
                    // Move to next item in playlist
                    moveToNextItem()
                }
            } else {
                if viewModel.groupMediaIndex > 0 {
                    viewModel.groupMediaIndex -= 1
                } else {
                    // Move to previous item in playlist
                    moveToPreviousItem()
                }
            }
        } else {
            // Handle navigation for single media
            if forward {
                moveToNextItem()
            } else {
                moveToPreviousItem()
            }
        }
    }
    
    private func moveToNextItem() {
        if let playlist = viewModel.playlist,
           viewModel.activeIndex < playlist.media.count - 1 {
            viewModel.activeIndex += 1
            viewModel.groupMediaIndex = 0 // Reset group index when moving to next item
        } else {
            // Close overlay if we're at the end
            if let quinn = global.quinn {
                var updatedQuinn = quinn
                updatedQuinn.overlayState = nil
                global.quinn = updatedQuinn
            }
        }
    }
    
    private func moveToPreviousItem() {
        if viewModel.activeIndex > 0 {
            viewModel.activeIndex -= 1
            // When moving to previous item, set group index to last item if it's a group
            if let previousItem = viewModel.playlist?.media[viewModel.activeIndex],
               previousItem.type == .group,
               let group = previousItem.group {
                viewModel.groupMediaIndex = group.medias.count - 1
            } else {
                viewModel.groupMediaIndex = 0
            }
        }
    }
    
    private func getAllProducts() -> [MediaProduct] {
        switch mediaItem.type {
        case .media:
            return mediaItem.media?.products ?? []
        case .group:
            if let group = mediaItem.group {
                let currentMedia = group.medias[viewModel.groupMediaIndex]
                return currentMedia.products
            }
            return []
        }
    }
}




