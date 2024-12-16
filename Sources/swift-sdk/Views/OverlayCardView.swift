//
//  OverlayCardView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct OverlayCardView: View {
    let mediaItem: PlaylistMediaItem
    @ObservedObject var viewModel: OverlayViewModel
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Render content based on media type
                if mediaItem.type == .media {
                    // Single media view
                    if let media = mediaItem.media {
                        singleMediaContent(media: media, proxy: proxy)
                    }
                } else if mediaItem.type == .group {
                    // Group/Bundle view
                    if let group = mediaItem.group {
                        let currentMedia = group.medias[viewModel.groupMediaIndex]
                        singleMediaContent(media: currentMedia, proxy: proxy)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            // Navigation overlay
            .overlay(
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
            )
            // Progress indicators for group/bundle
            .overlay(
                Group {
                    if case .group = mediaItem.type,
                       let group = mediaItem.group {
                        // Show progress indicators for group items
                        HStack(spacing: 4) {
                            ForEach(0..<group.medias.count, id: \.self) { index in
                                Rectangle()
                                    .fill(index == viewModel.groupMediaIndex ? Color.white : Color.white.opacity(0.5))
                                    .frame(height: 2)
                            }
                        }
                        .padding()
                    }
                },
                alignment: .top
            )
            // Close button
            .overlay(
                Button {
                    viewModel.global.quinn.overlayState = nil
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                },
                alignment: .topTrailing
            )
        }
    }
    
    @ViewBuilder
    private func singleMediaContent(media: PlaylistMedia, proxy: GeometryProxy) -> some View {
        if let videoUrl = media.urls?.short {
            VideoPlayer(url: URL(string: videoUrl))
                .aspectRatio(9/16, contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else if let posterUrl = media.urls?.poster {
            AsyncImage(url: URL(string: posterUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fill)
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
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
            viewModel.global.quinn.overlayState = nil
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
}


